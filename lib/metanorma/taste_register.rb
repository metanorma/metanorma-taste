# frozen_string_literal: true

require "singleton"
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

      return @taste_instances[flavor_sym] if @taste_instances[flavor_sym]

      config = @taste_configs[flavor_sym]
      raise UnknownTasteError, "Unknown taste: #{flavor}" unless config

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

      taste_directories = find_taste_directories(data_directory_path)
      taste_directories.each { |dir| load_taste_from_directory(dir) }
    end

    # Get the path to the data directory
    #
    # @return [String] Path to the data directory
    def data_directory
      File.join(File.dirname(__FILE__), "..", "..", "data")
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

    # Load and register a taste configuration from a directory
    #
    # @param taste_directory [String] Path to the taste directory
    # @raise [InvalidTasteConfigError] If the configuration is invalid
    def load_taste_from_directory(taste_directory)
      config_file = File.join(taste_directory, "config.yaml")
      directory_name = File.basename(taste_directory)

      begin
        config_content = File.read(config_file)
        config = Taste::TasteConfig.from_yaml(config_content)

        validate_taste_config!(config, directory_name)
        register_taste_config(config, taste_directory)
      rescue StandardError => e
        raise InvalidTasteConfigError,
              "Failed to load taste from #{taste_directory}: #{e.message}"
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

      # Create dynamic class if it doesn't exist
      class_name = flavor.to_s.capitalize
      unless Taste.const_defined?(class_name)
        Taste.const_set(class_name, Class.new(Taste::Base))
      end

      # Create instance of the dynamic class
      dynamic_class = Taste.const_get(class_name)
      dynamic_class.new(flavor, config, directory: directory)
    end

    # Get the directory path for a registered flavor
    #
    # @param flavor [Symbol] The flavor name
    # @return [String] The directory path
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
