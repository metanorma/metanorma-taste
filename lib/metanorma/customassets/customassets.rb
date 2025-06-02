module Metanorma
  class CustomAssets
    def initialize(flavor)
      @flavor = flavor
    end

    def self.aliases
      { icc: :iso }
    end

    def process_input_adoc_overrides(attrs, options)
      # Insert after the second element (index 1)
      # If attrs has fewer than 2 elements, this will handle it appropriately
      insertion_index = [attrs.length, 2].min
      case @flavor
      when :icc
        f1 = File.join(File.dirname(__FILE__), "assets", "icc-boilerplate.adoc")
        f2 = File.join(File.dirname(__FILE__), "assets", "icc-i18n.yaml")
        new_attrs = [
          ":boilerplate-authority: #{f1}",
          ":i18nyaml: #{f2}",
          ":publisher: International Color Consortium",
          ":publisher_abbr: ICC",
        ]
        attrs.insert(insertion_index, *new_attrs)
        options[":boilerplate-authority:"] = f1
      end
      attrs
    end
  end
end
