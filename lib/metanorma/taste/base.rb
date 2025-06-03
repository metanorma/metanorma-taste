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

        new_attrs = build_attribute_overrides
        attrs.insert(insertion_index, *new_attrs) unless new_attrs.empty?

        # Set boilerplate authority if copyright notice exists
        copyright_file = copyright_notice_path
        if copyright_file && File.exist?(copyright_file)
          options[":boilerplate-authority:"] = copyright_file
        end

        attrs
      end

      private

      def build_attribute_overrides
        overrides = []

        # Add copyright notice if available
        copyright_file = copyright_notice_path
        if copyright_file && File.exist?(copyright_file)
          overrides << ":boilerplate-authority: #{copyright_file}"
        end

        # Add i18n dictionary if available
        i18n_file = i18n_dictionary_path
        if i18n_file && File.exist?(i18n_file)
          overrides << ":i18nyaml: #{i18n_file}"
        end

        # Add base-override attributes
        @taste_info[:base_override].each do |key, value|
          overrides << ":#{key}: #{value}"
        end

        overrides
      end

      def copyright_notice_path
        return nil unless @taste_info[:copyright_notice]

        File.join(@taste_info[:directory], @taste_info[:copyright_notice])
      end

      def i18n_dictionary_path
        return nil unless @taste_info[:i18n_dictionary]

        File.join(@taste_info[:directory], @taste_info[:i18n_dictionary])
      end

      def load_i18n_dictionary
        i18n_file = i18n_dictionary_path
        return {} unless i18n_file && File.exist?(i18n_file)

        YAML.load_file(i18n_file)
      rescue StandardError
        {}
      end
    end
  end
end
