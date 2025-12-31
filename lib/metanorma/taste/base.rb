# frozen_string_literal: true

require_relative "taste_config"
require_relative "doctype"

module Metanorma
  module Taste
    # Base processor for taste-specific document attribute handling
    #
    # This class handles the processing of AsciiDoc attributes for
    # taste-specific # document generation, including filename-based attributes,
    # value-based attributes,and doctype-specific transformations.
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

      # @return [String] The directory in which the configuration for a taste
      # is stored, including file attributes
      attr_reader :directory

      # Mapping of value-based attribute configuration keys to AsciiDoc
      # attribute names
      #
      # This constant defines how base_override.value_attributes configuration
      # properties are translated into AsciiDoc document attributes.
      #
      # @example Configuration to attribute mapping
      #   config.base_override.value_attributes.publisher => :publisher:
      #   config.base_override.value_attributes.presentation_metadata_color_secondary => :presentation-metadata-color-secondary:
      #
      # TODO: metaprogramming to extract these from value_attributes.rb
      VALUE_ATTRIBUTE_MAPPINGS = {
        publisher: "publisher",
        publisher_abbr: "publisher_abbr",
        presentation_metadata_color_secondary: "presentation-metadata-color-secondary",
        presentation_metadata_backcover_text: "presentation-metadata-backcover-text",
        presentation_metadata_ul_label_list: "presentation-metadata-ul-label-list",
        presentation_metadata_annex_delim: "presentation-metadata-annex-delim",
        presentation_metadata_middle_title: "presentation-metadata-middle-title",
        presentation_metadata_ol_label_template_alphabet: "presentation-metadata-ol-label-template-alphabet",
        presentation_metadata_ol_label_template_alphabet_upper: "presentation-metadata-ol-label-template-alphabet_upper",
        presentation_metadata_ol_label_template_roman: "presentation-metadata-ol-label-template-roman",
        presentation_metadata_ol_label_template_roman_upper: "presentation-metadata-ol-label-template-roman_upper",
        presentation_metadata_ol_label_template_arabic: "presentation-metadata-ol-label-template-arabic",
        body_font: "body-font",
        header_font: "header-font",
        monospace_font: "monospace-font",
        fonts: "fonts",
        output_extensions: "output-extensions",
        toclevels: "toclevels",
        htmltoclevels: "toclevels-html",
        doctoclevels: "toclevels-doc",
        pdftoclevels: "toclevels-pdf",
        toc_figures: "toc-figures",
        toc_tables: "toc-tables",
        toc_recommendations: "toc-recommendations",
      }.freeze

      # Additive value attributes: if the document already has a value for this
      # attribute, add the taste config values to it
      VALUE_ATTR_ADDITIVE = {
        fonts: { delimiter: ";" },
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
      # @param options [Hash] Options hash that may be modified with additional
      # settings
      # @return [Array<String>] Modified array of AsciiDoc attributes
      #
      # @example
      #   attrs = [":doctype: specification", ":title: My Document"]
      #   options = {}
      #   result = base.process_input_adoc_overrides(attrs, options)
      #   # => [":doctype: specification", ":title: My Document", ":publisher: ICC", ...]
      def process_input_adoc_overrides(attrs, options)
        # Insert new attributes after the second element
        # (or at the end if fewer elements)
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

      # Build all attribute overrides from various sources
      #
      # This method coordinates the building of attributes from:
      # - Filename-based attributes (copyright, logo, i18n, stylesheets)
      # - Value-based attributes (publisher, fonts, presentation metadata)
      # - Doctype-specific overrides
      #
      # @param attrs [Array<String>] Original attributes array
      # @return [Array<Array<String>, Array<String>>] Tuple of [original_attrs, override_attrs]
      def build_all_attribute_overrides(attrs)
        override_attrs = []
        # Add attributes from different sources
        add_file_based_overrides(override_attrs)
        add_base_configuration_overrides(override_attrs, attrs)
        apply_doctype_overrides(attrs, override_attrs)
        [attrs, override_attrs]
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

      # Add filename-based attribute overrides
      #
      # Processes filename-based configuration properties
      # from base_override.filename_attributes
      # and adds corresponding attributes if the files exist.
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      def add_file_based_overrides(override_attrs)
        file_override_mappings.each do |config_attr, attr_name|
          add_file_override(override_attrs, config_attr, attr_name)
        end
      end

      # Get the mapping of filename-based configuration attributes to AsciiDoc
      # attributes
      #
      # @return [Hash<Symbol, String>] Mapping of config attributes to AsciiDoc
      # attribute names
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
          header: "header",
          standardstylesheet: "standardstylesheet",
          standardstylesheet_override: "standardstylesheet-override",
          pdfstylesheet: "pdf-stylesheet",
          pdfstylesheet_override: "pdf-stylesheet-override",
          customize: "customize",
          coverpage_image: "coverpage-image",
          backpage_image: "backpage-image",
          coverpage_pdf_portfolio: "coverpage-pdf-portfolio",
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

      # Get the full file path for a filename-based configuration attribute
      #
      # @param config_attr [Symbol] The configuration attribute name
      # @return [String, nil] The full file path, or nil if not configured
      #
      # @example
      #   file_path_for(:copyright_notice)  # => "data/icc/copyright.adoc"
      #   file_path_for(:publisher_logo)    # => "data/icc/logo.svg"
      def file_path_for(config_attr)
        return nil unless @config.base_override&.filename_attributes

        filename = @config.base_override.filename_attributes.send(config_attr)
        return nil unless filename

        File.join(@directory, filename)
      end

      # Add value-based configuration override attributes
      #
      # Processes base_override.value_attributes configuration and adds
      # corresponding AsciiDoc attributes for each configured property.
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      # @param attrs [Array<String>] Existing document attributes
      def add_base_configuration_overrides(override_attrs, attrs)
        @config.base_override&.value_attributes or return
        VALUE_ATTRIBUTE_MAPPINGS.each do |config_key, attr_key|
          value = @config.base_override.value_attributes.send(config_key)
          value or next
          value += add_base_configuration_additive(config_key, attr_key, attrs)
          override_attrs << ":#{attr_key}: #{value}"
        end
      end

      # If config base attribute already appears as a document attribute,
      # and expect it to be additive, add the old value before the config value
      def add_base_configuration_additive(config_key, attr_key, attrs)
        delim = VALUE_ATTR_ADDITIVE.dig(config_key, :delimiter)
        idx = attrs.find_index { |x| x.start_with?(":#{attr_key}: ") }
        if delim && idx
          old_val = attrs.delete_at(idx)
          delim + old_val.sub(":#{attr_key}: ", "").strip
        else ""
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
