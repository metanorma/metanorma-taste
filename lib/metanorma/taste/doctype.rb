module Metanorma
  module Taste
    class Base

      private

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
        doctype_config.abbrev and
          override_attrs << ":doctype-abbrev: #{doctype_config.abbrev}"

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
    end
  end
end
