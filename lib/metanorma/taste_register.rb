# frozen_string_literal: true

require "singleton"
require "yaml"
require_relative "taste/taste_config"
require_relative "taste/base"

module Metanorma
  # Registry for managing and providing access to taste configurations
  #
  # This singleton class automatically discovers taste configurations from the data directory,
  # loads them using lutaml-model, and provides a centralized registry for accessing
  # taste instances and their metadata.
  #
  # @example Basic usage
  #   # Get a taste instance
  #   icc_taste = TasteRegister.get("icc")
  #
  #   # List available tastes
  #   TasteRegister.available_tastes
  #   # => [:icc, :elf, :enosema]
  #
  #   # Get taste configuration
  #   config = TasteRegister.get_config("icc")
  #   # => #<Metanorma::Taste::TasteConfig:...>
  #   puts config.owner  # => "International Color Consortium"
  class TasteRegister
    include Singleton

    # Error raised when an unknown taste is requested
    class UnknownTasteError < StandardError; end

    # Error raised when taste configuration is invalid
    class InvalidTasteConfigError < StandardError; end

    def initialize
      @taste_configs = {}
      @taste_instances = {}
      discover_and_load_tastes
    end

    # Get a taste instance by flavor name
    #
    # @param flavor [String, Symbol] The flavor name (e.g., "icc", "elf")
    # @return [Taste::Base] The taste instance
    # @raise [UnknownTasteError] If the flavor is not registered
    #
    # @example
    #   taste = TasteRegister.get("icc")
    #   taste.process_input_adoc_overrides(attrs, options)
    def self.get(flavor)
      instance.get(flavor)
    end

    # Get a taste instance by flavor name
    #
    # @param flavor [String, Symbol] The flavor name
    # @return [Taste::Base] The taste instance
    # @raise [UnknownTasteError] If the flavor is not registered
    def get(flavor)
      flavor_sym = normalize_flavor_name(flavor)
      ret = @taste_instances[flavor_sym] and return ret
      config = @taste_configs[flavor_sym] or
        raise UnknownTasteError, "Unknown taste: #{flavor}"
      @taste_instances[flavor_sym] = create_taste_instance(flavor_sym, config)
    end

    # Get list of available taste flavors
    #
    # @return [Array<Symbol>] Array of available flavor names
    #
    # @example
    #   TasteRegister.available_tastes
    #   # => [:icc, :elf, :enosema]
    def available_tastes
      @taste_configs.keys
    end

    # Register a per-taste document-model transformer contribution. Called from
    # a taste's optional +data/<taste>/transformers.rb+ shim. The block is
    # evaluated lazily by {#document_transformers_for} and must return a
    # +{ format_symbol => spec }+ hash conforming to the metanorma-core
    # +Processor#document_transformers+ contract. Because the block runs lazily,
    # it may +require+ the gem that provides the transformer classes (e.g.
    # metanorma-oiml), so that gem loads only for builds that use the taste.
    def self.register_document_transformers(taste, &block)
      instance.register_document_transformers(taste, &block)
    end

    def register_document_transformers(taste, &block)
      (@transformer_hooks ||= {})[normalize_flavor_name(taste)] = block
    end

    # The document-model transformer specs contributed by +taste+ (e.g. the
    # OIML taste's STS transformer), or +{}+ when the taste declares none.
    # Memoised. The taste's +transformers.rb+ shim is required on first use, so
    # the artefact gem loads only for a build that uses this taste. The compile
    # driver forces this on the main thread (resolving output extensions) before
    # parallel output workers read it.
    def self.document_transformers_for(taste)
      instance.document_transformers_for(taste)
    end

    def document_transformers_for(taste)
      sym = normalize_flavor_name(taste)
      @transformer_specs ||= {}
      return @transformer_specs[sym] if @transformer_specs.key?(sym)

      load_transformer_hook(sym)
      block = (@transformer_hooks ||= {})[sym]
      @transformer_specs[sym] = block ? block.call : {}
    end

    # Get detailed information about a specific taste
    #
    # @param flavor [String, Symbol] The flavor name
    # @return [TasteConfig, nil] The taste configuration object, or nil if not found
    #
    # @example
    #   config = TasteRegister.get_config("icc")
    #   puts config.owner  # => "International Color Consortium"
    def self.get_config(flavor)
      instance.get_config(flavor)
    end

    def get_config(flavor)
      flavor_sym = normalize_flavor_name(flavor)
      config = @taste_configs[flavor_sym]
      return nil unless config

      # Set the directory on the config object
      config.directory = config_directory_for(flavor_sym)
      config
    end

    # Get config attributes to be passed to IsoDoc::Convert.new
    #
    # @param flavor [String, Symbol] The flavor name
    # @param format [Symbol] The format name
    # @return [Hash] A hash of format-specific config attributes
    #
    # @example
    #   config = TasteRegister.get_config("icc")
    #   puts config.owner  # => "International Color Consortium"
    def self.isodoc_attrs(flavor, format)
      instance.isodoc_attrs(flavor, format)
    end

    class NodeAttr
      def initialize(options)
        @options = options
      end

      def attr(key)
        @options[key]
      end
    end

    def isodoc_attrs(flavor, format)
      require "metanorma-standoc" unless defined?(::Metanorma::Standoc)
      
      # Define ExtractorHelper class dynamically after metanorma-standoc is loaded
      extractor_class = Class.new do
        include ::Metanorma::Standoc::Base

        def initialize(attrs_hash)
          @attrs_hash = attrs_hash
          @htmltoclevels = nil
          @doctoclevels = nil
          @pdftoclevels = nil
          @tocfigures = nil
          @toctables = nil
          @tocrecommendations = nil
          @localdir = Dir.pwd
        end

        def create_node
          TasteRegister::NodeAttr.new(@attrs_hash)
        end

        def i18nyaml_path(node)
          node.attr("i18nyaml")
        end

        def relaton_render_path(node)
          node.attr("relaton-render-config")
        end
      end
      
      taste = get(flavor)
      _, overrides = taste.build_all_attribute_overrides([])
      
      # Convert overrides array to hash
      attrs_hash = overrides.each_with_object({}) do |attr_str, hash|
        if attr_str =~ /^:([^:]+):\s*(.*)$/
          hash[$1] = $2
        end
      end
      
      helper = extractor_class.new(attrs_hash)
      node = helper.create_node
      
      case format
      when :html then helper.html_extract_attributes(node)
      when :pdf then helper.pdf_extract_attributes(node)
      when :doc then helper.doc_extract_attributes(node)
      else {}
      end
    end

    # Get flavor aliases mapping
    #
    # @return [Hash<Symbol, Symbol>] Mapping of flavor to base_flavor
    #
    # @example
    #   aliases = TasteRegister.instance.aliases
    #   # => { icc: :iso, elf: :iso, enosema: :iso }
    def self.aliases
      instance.aliases
    end

    def aliases
      @taste_configs.each_with_object({}) do |(flavor, config), aliases|
        aliases[flavor] = config.base_flavor&.to_sym if config.base_flavor
      end
    end

    private

    # Discover and load all taste configurations from the data directory
    #
    # Scans the data directory for subdirectories containing config.yaml files,
    # loads each configuration using lutaml-model, and registers them.
    def discover_and_load_tastes
      data_directory_path = data_directory
      return unless data_directory_path && Dir.exist?(data_directory_path)

      # Phase 1: collect every taste's raw config, so a parent named by a
      # child's `base-taste` is available regardless of directory iteration
      # order. Phase 2: resolve inheritance and register.
      raw = collect_raw_taste_configs(
        find_taste_directories(data_directory_path),
      )
      raw.each_key { |flavor| resolve_and_register_taste(flavor, raw) }
    end

    # Phase 1: read each taste dir's config.yaml into a raw hash keyed by flavor.
    #
    # @param taste_directories [Array<String>]
    # @return [Hash{String => Hash}] flavor => {"hash","content","directory"}
    def collect_raw_taste_configs(taste_directories)
      taste_directories.each_with_object({}) do |dir, acc|
        # explicit encoding: config files are UTF-8, the process locale may
        # not be (metanorma-cli sets Encoding.default_external to UTF-8, but
        # library consumers loading the register directly have no such shield)
        content = File.read(File.join(dir, "config.yaml"),
                            encoding: "UTF-8")
        hash = YAML.safe_load(content) || {}
        flavor = (hash["flavor"] || File.basename(dir)).to_s
        acc[flavor] = { "hash" => hash, "content" => content,
                        "directory" => dir }
      end
    end

    # Get the path to the data directory
    #
    # @return [String] Path to the data directory
    def data_directory
      Pathname.new(File.join(File.dirname(__FILE__), "..", "..", "data")).cleanpath.to_s
    end

    # Find all valid taste directories in the data directory
    #
    # @param data_dir [String] Path to the data directory
    # @return [Array<String>] Array of taste directory paths
    def find_taste_directories(data_dir)
      Dir.entries(data_dir)
        .reject { |entry| entry.start_with?(".") }
        .map { |entry| File.join(data_dir, entry) }
        .select { |path| Dir.exist?(path) && has_config_file?(path) }
    end

    # Check if a directory contains a config.yaml file
    #
    # @param directory [String] Directory path to check
    # @return [Boolean] True if config.yaml exists
    def has_config_file?(directory)
      File.exist?(File.join(directory, "config.yaml"))
    end

    # Phase 2: resolve any `base-taste` inheritance for one taste, then
    # validate and register the flattened config.
    #
    # @param flavor [String] flavor key into +raw+
    # @param raw [Hash] the phase-1 collection
    # @raise [InvalidTasteConfigError] If the configuration is invalid
    def resolve_and_register_taste(flavor, raw)
      entry = raw[flavor]
      if entry["hash"]["base-taste"]
        merged, search_path = resolve_raw_config(flavor, raw, [])
        yaml = merged.to_yaml
      else
        # No inheritance: parse the original content verbatim, so behaviour
        # for existing tastes is identical to the previous single-pass loader.
        yaml = entry["content"]
        search_path = [entry["directory"]]
      end

      config = Taste::TasteConfig.from_yaml(yaml)
      validate_taste_config!(config, File.basename(entry["directory"]))
      register_taste_config(config, entry["directory"])
      (@config_directory_search_paths ||= {})[flavor.to_sym] = search_path
    rescue StandardError => e
      raise InvalidTasteConfigError,
            "Failed to load taste from #{raw[flavor]['directory']}: #{e.message}"
    end

    # Recursively merge a taste's `base-taste` ancestry into its own raw
    # config. Child keys win: hashes merge deeply, arrays and scalars replace.
    #
    # @param flavor [String] flavor key into +raw+
    # @param raw [Hash] the phase-1 collection
    # @param in_progress [Array<String>] chain being resolved (cycle guard)
    # @return [Array(Hash, Array<String>)] [merged raw hash, dir search path]
    # @raise [InvalidTasteConfigError] on a cycle or an unknown base-taste
    def resolve_raw_config(flavor, raw, in_progress)
      if in_progress.include?(flavor)
        raise InvalidTasteConfigError,
              "Cyclic base-taste inheritance: " \
              "#{(in_progress + [flavor]).join(' -> ')}"
      end
      entry = raw[flavor] or
        raise InvalidTasteConfigError, "Unknown base-taste: #{flavor}"

      hash = entry["hash"]
      dir = entry["directory"]
      parent = hash["base-taste"]
      return [hash, [dir]] unless parent

      parent_merged, parent_path =
        resolve_raw_config(parent.to_s, raw, in_progress + [flavor])
      merged = deep_merge(parent_merged, hash)
      merged.delete("base-taste")
      [merged, [dir, *parent_path]]
    end

    # Deep-merge +override+ onto +base+: recurse into hashes; arrays and
    # scalars in +override+ replace those in +base+.
    #
    # @return [Hash] a new merged hash (inputs are not mutated)
    def deep_merge(base, override)
      base.merge(override) do |_key, base_val, over_val|
        if base_val.is_a?(Hash) && over_val.is_a?(Hash)
          deep_merge(base_val, over_val)
        else
          over_val
        end
      end
    end

    # Validate that a taste configuration is complete and valid
    #
    # @param config [Taste::TasteConfig] The configuration to validate
    # @param directory_name [String] The directory name for fallback
    # @raise [InvalidTasteConfigError] If validation fails
    def validate_taste_config!(config, directory_name)
      unless config.flavor || directory_name
        raise InvalidTasteConfigError, "Taste must have a flavor name"
      end

      # Validate that base-override.value-attributes.output-extensions is present and not empty
      unless config.base_override&.value_attributes&.output_extensions&.strip&.length&.positive?
        raise InvalidTasteConfigError, "Taste must have base-override.value-attributes.output-extensions defined"
      end

      # Auto-enhance output-extensions: if it contains xml and any of html/doc/pdf,
      # and doesn't already contain "presentation", then add "presentation"
      if config.base_override&.value_attributes&.output_extensions
        extensions = config.base_override.value_attributes.output_extensions.split(",").map(&:strip)
        
        if extensions.include?("xml") && 
            (extensions.include?("html") || extensions.include?("doc") || extensions.include?("pdf")) &&
            !extensions.include?("presentation")
          extensions << "presentation"
          config.base_override.value_attributes.output_extensions = extensions.join(",")
        end
      end
    end

    # Register a taste configuration in the registry
    #
    # @param config [Taste::TasteConfig] The configuration to register
    # @param directory [String] The taste directory path
    def register_taste_config(config, directory)
      # Use config flavor or fall back to directory name
      flavor = config.flavor&.to_sym || File.basename(directory).to_sym

      # Store the config and remember its directory
      @taste_configs[flavor] = config
      @config_directories ||= {}
      @config_directories[flavor] = directory
    end

    # Create a taste instance for the given flavor and configuration
    #
    # @param flavor [Symbol] The flavor name
    # @param config [Taste::TasteConfig] The taste configuration
    # @return [Taste::Base] The created taste instance
    def create_taste_instance(flavor, config)
      directory = config_directory_for(flavor)
      search_path = (@config_directory_search_paths ||= {})[flavor] ||
        [directory]

      # Create dynamic class if it doesn't exist
      class_name = flavor.to_s.split(/[-_]/).map(&:capitalize).join
      unless Taste.const_defined?(class_name)
        Taste.const_set(class_name, Class.new(Taste::Base))
      end

      # Create instance of the dynamic class
      dynamic_class = Taste.const_get(class_name)
      dynamic_class.new(flavor, config, directory: directory,
                                        directory_search_path: search_path)
    end

    # Get the directory path for a registered flavor
    #
    # @param flavor [Symbol] The flavor name
    # @return [String] The directory path
    # Require the taste's optional data/<taste>/transformers.rb shim once, if
    # present; it calls {#register_document_transformers} to register the taste's
    # document-model transformers.
    def load_transformer_hook(flavor)
      path = File.join(config_directory_for(flavor), "transformers.rb")
      require path if File.exist?(path)
    rescue LoadError => e
      raise UnknownTasteError,
            "Taste #{flavor} declares document transformers but its artefact " \
            "gem could not be loaded (#{e.message}); add it to your bundle."
    end

    def config_directory_for(flavor)
      @config_directories ||= {}
      @config_directories[flavor] || File.join(data_directory, flavor.to_s)
    end

    # Normalize flavor name to symbol
    #
    # @param flavor [String, Symbol] The flavor name
    # @return [Symbol] Normalized flavor name
    def normalize_flavor_name(flavor)
      flavor.to_sym
    end
  end
end
