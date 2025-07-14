# frozen_string_literal: true

require_relative "taste_config"

module Metanorma
  module Taste
    # Base processor for taste-specific document attribute handling
    #
    # This class handles the processing of AsciiDoc attributes for taste-specific
    # document generation, including file-based overrides, base configuration overrides,
    # and doctype-specific transformations.
    #
    # @example Basic usage
    #   config = TasteConfig.from_yaml(yaml_content)
    #   base = Base.new("icc", config, directory: "data/icc")
    #
    #   attrs = [":doctype: specification", ":title: My Document"]
    #   options = {}
    #   processed_attrs = base.process_input_adoc_overrides(attrs, options)
    #
    # @example Processing workflow
    #   # 1. File-based attributes are added (copyright, logo, i18n)
    #   # 2. Base override attributes are applied
    #   # 3. Doctype-specific transformations are performed
    #   # 4. Boilerplate authority is set in options if copyright exists
    class Base
      # @return [String, Symbol] The flavor identifier (e.g., :icc, :elf)
      attr_reader :flavor

      # @return [TasteConfig] The taste configuration object
      attr_reader :config

      # Mapping of base override configuration keys to AsciiDoc attribute names
      #
      # This constant defines how base_override configuration properties
      # are translated into AsciiDoc document attributes.
      #
      # @example Configuration to attribute mapping
      #   config.base_override.publisher => :publisher:
      #   config.base_override.presentation_metadata_color_secondary => :presentation-metadata-color-secondary:
      BASE_OVERRIDE_MAPPINGS = {
        publisher: "publisher",
        publisher_abbr: "publisher_abbr",
        presentation_metadata_color_secondary: "presentation-metadata-color-secondary",
        presentation_metadata_backcover_text: "presentation-metadata-backcover-text",
        body_font: "body-font",
        header_font: "header-font",
        monospace_font: "monospace-font",
      }.freeze

      # Initialize a new Base processor
      #
      # @param flavor [String, Symbol] The taste flavor identifier
      # @param config [TasteConfig] The taste configuration object
      # @param directory [String] The base directory for taste files (default: current directory)
      #
      # @example
      #   config = TasteConfig.from_yaml(File.read("config.yaml"))
      #   base = Base.new("icc", config, directory: "data/icc")
      def initialize(flavor, config, directory: Dir.pwd)
        @flavor = flavor
        @config = config
        @directory = directory
      end

      # Process input AsciiDoc attributes with taste-specific overrides
      #
      # This is the main entry point for attribute processing. It applies
      # file-based overrides, base configuration overrides, and doctype
      # transformations to the input attributes.
      #
      # @param attrs [Array<String>] Array of AsciiDoc attribute strings
      # @param options [Hash] Options hash that may be modified with additional settings
      # @return [Array<String>] Modified array of AsciiDoc attributes
      #
      # @example
      #   attrs = [":doctype: specification", ":title: My Document"]
      #   options = {}
      #   result = base.process_input_adoc_overrides(attrs, options)
      #   # => [":doctype: specification", ":title: My Document", ":publisher: ICC", ...]
      def process_input_adoc_overrides(attrs, options)
        # Insert new attributes after the second element (or at the end if fewer elements)
        insertion_index = calculate_insertion_index(attrs)

        # Build and insert override attributes
        attrs, override_attrs = build_all_attribute_overrides(attrs)
        unless override_attrs.empty?
          attrs.insert(insertion_index,
                       *override_attrs)
        end

        # Set boilerplate authority in options if copyright notice exists
        set_boilerplate_authority_option(options)

        attrs
      end

      private

      # Calculate the appropriate insertion index for new attributes
      #
      # Attributes are inserted after the second element to maintain
      # proper AsciiDoc document structure.
      #
      # @param attrs [Array] The attributes array
      # @return [Integer] The insertion index
      def calculate_insertion_index(attrs)
        [attrs.length, 2].min
      end

      # Build all attribute overrides from various sources
      #
      # This method coordinates the building of attributes from:
      # - File-based sources (copyright, logo, i18n)
      # - Base override configuration
      # - Doctype-specific overrides
      #
      # @param attrs [Array<String>] Original attributes array
      # @return [Array<Array<String>, Array<String>>] Tuple of [original_attrs, override_attrs]
      def build_all_attribute_overrides(attrs)
        override_attrs = []

        # Add attributes from different sources
        add_file_based_overrides(override_attrs)
        add_base_configuration_overrides(override_attrs)
        apply_doctype_overrides(attrs, override_attrs)

        [attrs, override_attrs]
      end

      # Add file-based attribute overrides
      #
      # Processes file-based configuration properties and adds corresponding
      # attributes if the files exist.
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      def add_file_based_overrides(override_attrs)
        file_override_mappings.each do |config_attr, attr_name|
          add_file_override(override_attrs, config_attr, attr_name)
        end
      end

      # Get the mapping of file-based configuration attributes to AsciiDoc attributes
      #
      # @return [Hash<Symbol, String>] Mapping of config attributes to AsciiDoc attribute names
      def file_override_mappings
        {
          copyright_notice: "boilerplate-authority",
          publisher_logo: "publisher_logo",
          i18n_dictionary: "i18nyaml",
          htmlcoverpage: "htmlcoverpage",
          htmlintropage: "htmlintropage",
          htmlstylesheet: "htmlstylesheet",
          htmlstylesheet_override: "htmlstylesheet-override",
          wordcoverpage: "wordcoverpage",
          wordintropage: "wordintropage",
          wordstylesheet: "wordstylesheet",
          wordstylesheet_override: "wordstylesheet-override",
          pdfstylesheet: "pdfstylesheet",
          pdfstylesheet_override: "pdfstylesheet-override",
        }
      end

      # Add a single file-based override attribute
      #
      # @param override_attrs [Array<String>] Array to append to
      # @param config_attr [Symbol] Configuration attribute name
      # @param attr_name [String] AsciiDoc attribute name
      def add_file_override(override_attrs, config_attr, attr_name)
        filepath = file_path_for(config_attr)
        return unless filepath && File.exist?(filepath)

        override_attrs << ":#{attr_name}: #{filepath}"
      end

      # Get the full file path for a configuration attribute
      #
      # @param config_attr [Symbol] The configuration attribute name
      # @return [String, nil] The full file path, or nil if not configured
      #
      # @example
      #   file_path_for(:copyright_notice)  # => "data/icc/copyright.adoc"
      #   file_path_for(:publisher_logo)    # => "data/icc/logo.svg"
      def file_path_for(config_attr)
        filename = @config.send(config_attr)
        return nil unless filename

        File.join(@directory, filename)
      end

      # Add base configuration override attributes
      #
      # Processes base_override configuration and adds corresponding
      # AsciiDoc attributes for each configured property.
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      def add_base_configuration_overrides(override_attrs)
        return unless @config.base_override

        BASE_OVERRIDE_MAPPINGS.each do |config_key, attr_key|
          value = @config.base_override.send(config_key)
          next unless value

          override_attrs << ":#{attr_key}: #{value}"
        end
      end

      # Apply doctype-specific overrides and transformations
      #
      # This method handles the transformation of doctype attributes based on
      # taste-specific doctype configurations. It:
      # 1. Finds the doctype attribute in the input
      # 2. Looks up the corresponding doctype configuration
      # 3. Transforms the doctype value (taste -> base)
      # 4. Adds doctype-specific override attributes
      #
      # @param attrs [Array<String>] The attributes array (modified in place)
      # @param override_attrs [Array<String>] Array to append override attributes to
      def apply_doctype_overrides(attrs, override_attrs)
        doctype_index = find_doctype_attribute_index(attrs)
        return unless doctype_index

        current_doctype = extract_doctype_value(attrs[doctype_index])
        doctype_config = find_doctype_configuration(current_doctype)
        return unless doctype_config

        # Transform the doctype attribute
        transform_doctype_attribute(attrs, doctype_index, doctype_config)

        # Add doctype-specific overrides
        add_doctype_specific_overrides(override_attrs, doctype_config)
      end

      # Find the index of the doctype attribute in the attributes array
      #
      # @param attrs [Array<String>] The attributes array
      # @return [Integer, nil] The index of the doctype attribute, or nil if not found
      def find_doctype_attribute_index(attrs)
        attrs.index { |attr| attr.match?(/^:doctype:/) }
      end

      # Extract the doctype value from a doctype attribute string
      #
      # @param doctype_attr [String] The doctype attribute string (e.g., ":doctype: specification")
      # @return [String] The doctype value (e.g., "specification")
      def extract_doctype_value(doctype_attr)
        doctype_attr.sub(/^:doctype:/, "").strip
      end

      # Find the doctype configuration for a given taste doctype
      #
      # @param taste_doctype [String] The taste-specific doctype name
      # @return [DoctypeConfig, nil] The doctype configuration, or nil if not found
      def find_doctype_configuration(taste_doctype)
        @config.doctypes&.detect { |dt| dt.taste == taste_doctype }
      end

      # Transform the doctype attribute from taste-specific to base doctype
      #
      # @param attrs [Array<String>] The attributes array (modified in place)
      # @param doctype_index [Integer] The index of the doctype attribute
      # @param doctype_config [DoctypeConfig] The doctype configuration
      def transform_doctype_attribute(attrs, doctype_index, doctype_config)
        attrs[doctype_index] = ":doctype: #{doctype_config.base}"
      end

      # Add doctype-specific override attributes
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      # @param doctype_config [DoctypeConfig] The doctype configuration
      def add_doctype_specific_overrides(override_attrs, doctype_config)
        # Add the doctype alias for presentation metadata
        override_attrs << ":presentation-metadata-doctype-alias: #{doctype_config.taste}"

        # Add any additional override attributes defined in the doctype configuration
        add_doctype_override_attributes(override_attrs, doctype_config)
      end

      # Add override attributes defined in the doctype configuration
      #
      # The override_attributes property contains an array of hash objects,
      # where each hash contains key-value pairs for attribute overrides.
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      # @param doctype_config [DoctypeConfig] The doctype configuration
      def add_doctype_override_attributes(override_attrs, doctype_config)
        return unless doctype_config.override_attributes

        doctype_config.override_attributes.each do |attr_hash|
          attr_hash.each do |key, value|
            override_attrs << ":#{key}: #{value}"
          end
        end
      end

      # Set the boilerplate authority option if copyright notice exists
      #
      # This method checks for the existence of a copyright notice file
      # and sets the appropriate option for boilerplate processing.
      #
      # @param options [Hash] Options hash to modify
      def set_boilerplate_authority_option(options)
        copyright_file = copyright_notice_path
        return unless copyright_file && File.exist?(copyright_file)

        options[":boilerplate-authority:"] = copyright_file
      end

      # Get the full path to the copyright notice file
      #
      # @return [String, nil] The copyright notice file path, or nil if not configured
      #
      # @example
      #   copyright_notice_path  # => "data/icc/copyright.adoc"
      def copyright_notice_path
        file_path_for(:copyright_notice)
      end

      # Get the full path to the publisher logo file
      #
      # @return [String, nil] The publisher logo file path, or nil if not configured
      #
      # @example
      #   publisher_logo_path  # => "data/icc/logo.svg"
      def publisher_logo_path
        file_path_for(:publisher_logo)
      end

      # Get the full path to the i18n dictionary file
      #
      # @return [String, nil] The i18n dictionary file path, or nil if not configured
      #
      # @example
      #   i18n_dictionary_path  # => "data/icc/i18n.yaml"
      def i18n_dictionary_path
        file_path_for(:i18n_dictionary)
      end
    end
  end
end
