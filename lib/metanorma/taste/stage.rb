module Metanorma
  module Taste
    class Base
      private

      # Apply stage-specific overrides and transformations
      #
      # This method handles the transformation of stage attributes based on
      # taste-specific stage configurations. It:
      # 1. Finds the stage attribute in the input
      # 2. Looks up the corresponding stage configuration
      # 3. Transforms the stage value (taste -> base)
      # 4. Adds stage-specific override attributes
      #
      # @param attrs [Array<String>] The attributes array (modified in place)
      # @param override_attrs [Array<String>] Array to append override attributes to
      def apply_stage_overrides(attrs, override_attrs)
        stage_index = find_stage_attribute_index(attrs)
        stage_index ||= insert_default_stage(attrs)
        return unless stage_index

        current_stage = extract_stage_value(attrs[stage_index])
        stage_config = find_stage_configuration(current_stage)
        return unless stage_config

        # Transform the stage attribute
        transform_stage_attribute(attrs, stage_index, stage_config)

        # Add stage-specific overrides
        add_stage_specific_overrides(override_attrs, stage_config)
      end

      # Find the index of the stage attribute in the attributes array
      #
      # @param attrs [Array<String>] The attributes array
      # @return [Integer, nil] The index of the stage attribute, or nil if not found
      def find_stage_attribute_index(attrs)
        attrs.index { |attr| attr.match?(/^:(docstage|status):/) }
      end

      def insert_default_stage(attrs)
        s = @config.stages&.detect { |dt| dt.default == "true" }
        s or return
        attrs << ":docstage: #{s.taste}"
        attrs.size - 1
      end

      # Extract the stage value from a stage attribute string
      #
      # @param stage_attr [String] The stage attribute string (e.g., ":docstage: specification")
      # @return [String] The stage value (e.g., "specification")
      def extract_stage_value(stage_attr)
        stage_attr.sub(/^:(docstage|status):/, "").strip
      end

      # Find the stage configuration for a given taste stage
      #
      # @param taste_stage [String] The taste-specific stage name
      # @return [DoctypeConfig, nil] The stage configuration, or nil if not found
      def find_stage_configuration(taste_stage)
        @config.stages&.detect { |dt| dt.taste == taste_stage }
      end

      # Transform the stage attribute from taste-specific to base stage
      #
      # @param attrs [Array<String>] The attributes array (modified in place)
      # @param stage_index [Integer] The index of the stage attribute
      # @param stage_config [DoctypeConfig] The stage configuration
      def transform_stage_attribute(attrs, stage_index, stage_config)
        attrs[stage_index] = ":docstage: #{stage_config.base}"
      end

      # Add stage-specific override attributes
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      # @param stage_config [DoctypeConfig] The stage configuration
      def add_stage_specific_overrides(override_attrs, stage_config)
        # Add the stage alias for presentation metadata
        override_attrs << ":presentation-metadata-stage-alias: #{stage_config.taste}"
        stage_config.abbreviation and
          override_attrs << ":docstage-abbrev: #{stage_config.abbreviation}"
        stage_config.published == "true" and
          override_attrs << ":docstage-published: true"

        # Add any additional override attributes defined in the stage configuration
        # add_stage_override_attributes(override_attrs, stage_config)
      end

      # Add override attributes defined in the stage configuration
      #
      # The override_attributes property contains an array of hash objects,
      # where each hash contains key-value pairs for attribute overrides.
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      # @param stage_config [DoctypeConfig] The stage configuration
      # NOT CURRENTLY IMPLEMENTED
      #       def add_stage_override_attributes(override_attrs, stage_config)
      #         return unless stage_config.override_attributes
      #
      #         stage_config.override_attributes.each do |attr_hash|
      #           attr_hash.each do |key, value|
      #             override_attrs << ":#{key}: #{value}"
      #           end
      #         end
      #       end
    end
  end
end
