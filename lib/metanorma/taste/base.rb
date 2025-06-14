# frozen_string_literal: true

require "yaml"

module Metanorma
  module Taste
    class Base
      attr_reader :flavor, :config, :taste_info

      def initialize(flavor, taste_info)
        @flavor = flavor
        @taste_info = taste_info
        @config = taste_info[:config]
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
        build_attribute_copyright_overrides(overrides)
        build_attribute_i18n_overrides(overrides)
        # Add base-override attributes
        @taste_info[:base_override].each do |key, value|
          overrides << ":#{key}: #{value}"
        end
        build_attribute_doctype_overrides(attrs, overrides)
        [attrs, overrides]
      end

      # Add copyright notice if available
      def build_attribute_copyright_overrides(overrides)
        copyright_file = copyright_notice_path
        if copyright_file && File.exist?(copyright_file)
          overrides << ":boilerplate-authority: #{copyright_file}"
        end
      end

      # Add i18n dictionary if availablee
      def build_attribute_i18n_overrides(overrides)
        i18n_file = i18n_dictionary_path
        if i18n_file && File.exist?(i18n_file)
          overrides << ":i18nyaml: #{i18n_file}"
        end
      end

      def build_attribute_doctype_overrides(attrs, overrides)
        doctype_idx, dt = build_attribute_doctype_overrides_prep(attrs)
        dt.nil? and return
        overrides << ":presentation-metadata-doctype-alias: #{dt['taste']}"
        attrs[doctype_idx] = ":doctype: #{dt['base']}"
        dt["override_attributes"]&.each do |key, value|
          overrides << ":#{key}: #{value}"
        end
      end

      def build_attribute_doctype_overrides_prep(attrs)
        doctype_idx = attrs.index { |e| /^:doctype:/.match?(e) } or
          return [nil, nil, nil]
        old_doctype = attrs[doctype_idx].sub(/^:doctype:/, "").strip
        dt = @taste_info[:doctypes].detect do |e|
          e["taste"] == old_doctype
        end or return [nil, nil, nil]
        [doctype_idx, dt]
      end

      def copyright_notice_path
        @taste_info[:copyright_notice] or return nil
        File.join(@taste_info[:directory], @taste_info[:copyright_notice])
      end

      def i18n_dictionary_path
        @taste_info[:i18n_dictionary] or return nil
        File.join(@taste_info[:directory], @taste_info[:i18n_dictionary])
      end

      def load_i18n_dictionary
        i18n_file = i18n_dictionary_path
        i18n_file && File.exist?(i18n_file) or return {}
        YAML.load_file(i18n_file)
      rescue StandardError
        {}
      end
    end
  end
end
