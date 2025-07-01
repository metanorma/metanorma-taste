# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Taste
    # Model for base-override configuration
    class BaseOverride < Lutaml::Model::Serializable
      attribute :publisher, :string
      attribute :publisher_abbr, :string
      attribute :presentation_metadata_color_secondary, :string
      attribute :presentation_metadata_backcover_text, :string

      key_value do
        map "publisher", to: :publisher
        map "publisher_abbr", to: :publisher_abbr
        map "presentation-metadata-color-secondary",
            to: :presentation_metadata_color_secondary
        map "presentation-metadata-backcover-text",
            to: :presentation_metadata_backcover_text
      end
    end

    # Model for individual doctype configuration
    class DoctypeConfig < Lutaml::Model::Serializable
      attribute :taste, :string
      attribute :base, :string
      attribute :override_attributes, :hash, collection: true

      key_value do
        map "taste", to: :taste
        map "base", to: :base
        map "override-attributes", to: :override_attributes
      end
    end

    # Main configuration model
    class TasteConfig < Lutaml::Model::Serializable
      attribute :flavor, :string
      attribute :owner, :string
      attribute :base_flavor, :string
      attribute :copyright_notice, :string
      attribute :i18n_dictionary, :string
      attribute :publisher_logo, :string
      attribute :base_override, BaseOverride
      attribute :doctypes, DoctypeConfig, collection: true

      key_value do
        map "flavor", to: :flavor
        map "owner", to: :owner
        map "base-flavor", to: :base_flavor
        map "copyright-notice", to: :copyright_notice
        map "i18n-dictionary", to: :i18n_dictionary
        map "publisher-logo", to: :publisher_logo
        map "base-override", to: :base_override
        map "doctypes", to: :doctypes
      end
    end

    class Base
      attr_reader :flavor, :config

      def initialize(flavor, config, directory: Dir.pwd)
        @flavor = flavor
        @config = config
        @directory = directory
      end

      def process_input_adoc_overrides(attrs, options)
        # Insert after the second element (index 1)
        # If attrs has fewer than 2 elements, this will handle it appropriately
        insertion_index = [attrs.length, 2].min

        attrs, new_attrs = build_attribute_overrides(attrs)
        attrs.insert(insertion_index, *new_attrs) unless new_attrs.empty?

        # Set boilerplate authority if copyright notice exists
        copyright_file = copyright_notice_path
        if copyright_file && File.exist?(copyright_file)
          options[":boilerplate-authority:"] = copyright_file
        end

        attrs
      end

      private

      def build_attribute_overrides(attrs)
        overrides = []
        file_attr_override(:copyright_notice, "boilerplate-authority",
                           overrides)
        file_attr_override(:publisher_logo, "publisher_logo", overrides)
        file_attr_override(:i18n_dictionary, "i18nyaml", overrides)

        # Add base-override attributes
        if @config.base_override
          overrides << ":publisher: #{@config.base_override.publisher}" if @config.base_override.publisher
          overrides << ":publisher_abbr: #{@config.base_override.publisher_abbr}" if @config.base_override.publisher_abbr
          overrides << ":presentation-metadata-color-secondary: #{@config.base_override.presentation_metadata_color_secondary}" if @config.base_override.presentation_metadata_color_secondary
          overrides << ":presentation-metadata-backcover-text: #{@config.base_override.presentation_metadata_backcover_text}" if @config.base_override.presentation_metadata_backcover_text
        end

        build_attribute_doctype_overrides(attrs, overrides)
        [attrs, overrides]
      end

      def file_attr_override(source_attr_name, target_attr_name, overrides)
        s = @config.send(source_attr_name) or return nil
        f = File.join(@directory, s)
        if f && File.exist?(f)
          overrides << ":#{target_attr_name}: #{f}"
        end
      end

      def build_attribute_doctype_overrides(attrs, overrides)
        doctype_idx, dt = build_attribute_doctype_overrides_prep(attrs)
        dt.nil? and return
        overrides << ":presentation-metadata-doctype-alias: #{dt.taste}"
        attrs[doctype_idx] = ":doctype: #{dt.base}"

        if dt.override_attributes.is_a?(Hash)
          dt.override_attributes.each do |key, value|
            overrides << ":#{key}: #{value}"
          end
        elsif dt.override_attributes.is_a?(Array)
          dt.override_attributes.each do |attr_hash|
            attr_hash.each do |key, value|
              overrides << ":#{key}: #{value}"
            end
          end
        end
      end

      def build_attribute_doctype_overrides_prep(attrs)
        doctype_idx = attrs.index { |e| /^:doctype:/.match?(e) } or
          return [nil, nil, nil]
        old_doctype = attrs[doctype_idx].sub(/^:doctype:/, "").strip
        dt = @config.doctypes&.detect do |e|
          e.taste == old_doctype
        end or return [nil, nil, nil]
        [doctype_idx, dt]
      end

      def copyright_notice_path
        @config.copyright_notice or return nil
        File.join(@directory, @config.copyright_notice)
      end

      def publisher_logo_path
        @config.publisher_logo or return nil
        File.join(@directory, @config.publisher_logo)
      end

      def i18n_dictionary_path
        @config.i18n_dictionary or return nil
        File.join(@directory, @config.i18n_dictionary)
      end
    end
  end
end
