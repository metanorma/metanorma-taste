module Metanorma
  module Taste
    class Base
      private

      # Apply committee overrides and transformations
      #
      # This method handles the transformation of committee attributes based on
      # taste-specific committee configurations. It:
      # 1. Adds committee-types attribute listing all available categories
      # 2. Finds committee attributes in the input (e.g., :interoperability-forum:)
      # 3. Looks up the corresponding committee item by abbrev
      # 4. Transforms the committee value (abbrev -> full name)
      # 5. Adds committee-specific override attributes
      #
      # @param attrs [Array<String>] The attributes array (modified in place)
      # @param override_attrs [Array<String>] Array to append override attributes to
      def apply_committee_overrides(attrs, override_attrs)
        return unless @config.committees&.categories

        # Add committee-types attribute with all category keys
        add_committee_types(override_attrs)

        @config.committees.categories.each do |category|
          process_committee_category(attrs, override_attrs, category)
        end
      end

      # Add committee-types attribute listing all available committee categories
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      def add_committee_types(override_attrs)
        category_keys = @config.committees.categories.map(&:category_key)
        return if category_keys.empty?

        override_attrs << ":committee-types: #{category_keys.join(',')}"
      end

      # Process a single committee category
      #
      # @param attrs [Array<String>] The attributes array (modified in place)
      # @param override_attrs [Array<String>] Array to append override attributes to
      # @param category [CommitteeCategory] The committee category to process
      def process_committee_category(attrs, override_attrs, category)
        category_key = category.category_key
        matching_attrs = find_committee_attributes(attrs, category_key)

        matching_attrs.each do |index, suffix|
          attr_value = extract_committee_abbrev(attrs[index])
          next unless attr_value

          item = find_committee_item(category, attr_value)
          next unless item

          # Transform the committee attribute in place
          transform_committee_attribute(attrs, index, category_key, suffix,
                                        item)

          # Add committee-specific overrides
          add_committee_specific_overrides(override_attrs, category_key,
                                           suffix, item)
        end
      end

      # Find all committee attributes matching the category key
      #
      # @param attrs [Array<String>] The attributes array
      # @param category_key [String] The category key (e.g., "interoperability-forum")
      # @return [Array<Array(Integer, String)>] Array of [index, suffix] pairs
      def find_committee_attributes(attrs, category_key)
        results = []
        attrs.each_with_index do |attr, index|
          # Match either :{category_key}: or :{category_key}_\d+:
          if attr.match?(/^:#{Regexp.escape(category_key)}:/)
            results << [index, ""]
          elsif (match = attr.match(/^:#{Regexp.escape(category_key)}_(\d+):/))
            results << [index, "_#{match[1]}"]
          end
        end
        results
      end

      # Extract the committee abbreviation value from a committee attribute string
      #
      # @param committee_attr [String] The committee attribute string (e.g., ":interoperability-forum: CAx-IF")
      # @return [String, nil] The committee abbreviation value (e.g., "CAx-IF")
      def extract_committee_abbrev(committee_attr)
        value = committee_attr.sub(/^:[^:]+:/, "").strip
        value.empty? ? nil : value
      end

      # Find the committee item for a given abbreviation
      #
      # @param category [CommitteeCategory] The committee category
      # @param abbrev [String] The committee abbreviation
      # @return [CommitteeItem, nil] The committee item, or nil if not found
      def find_committee_item(category, abbrev)
        category.items&.detect { |item| item.abbrev == abbrev }
      end

      # Transform the committee attribute from abbreviation to full name
      #
      # @param attrs [Array<String>] The attributes array (modified in place)
      # @param index [Integer] The index of the committee attribute
      # @param category_key [String] The category key
      # @param suffix [String] The suffix (e.g., "" or "_2")
      # @param item [CommitteeItem] The committee item
      def transform_committee_attribute(attrs, index, category_key, suffix,
item)
        attrs[index] = ":#{category_key}#{suffix}: #{item.name}"
      end

      # Add committee-specific override attributes
      #
      # @param override_attrs [Array<String>] Array to append override attributes to
      # @param category_key [String] The category key
      # @param suffix [String] The suffix (e.g., "" or "_2")
      # @param item [CommitteeItem] The committee item
      def add_committee_specific_overrides(override_attrs, category_key,
suffix, item)
        # Add abbrev
        override_attrs << ":#{category_key}-abbrev#{suffix}: #{item.abbrev}"

        # Add number if present
        if item.number && !item.number.empty?
          override_attrs << ":#{category_key}-number#{suffix}: #{item.number}"
        end

        # Add logo if present, resolved to absolute path
        if item.logo && !item.logo.empty?
          logo_path = committee_logo_path(item.logo)
          override_attrs << ":#{category_key}_logo#{suffix}: #{logo_path}"
        end
      end

      # Get the full path to a committee logo file
      #
      # @param logo_filename [String] The logo filename
      # @return [String] The full path to the logo file
      def committee_logo_path(logo_filename)
        File.join(@directory, logo_filename)
      end
    end
  end
end
