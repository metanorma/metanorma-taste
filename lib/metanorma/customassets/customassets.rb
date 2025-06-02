module Metanorma
  class CustomAssets
    def initialize(flavor)
      @flavor = flavor
    end

    def self.aliases
      { icc: :iso }
    end

    def process_input_adoc_overrides(attrs, options)
      case @flavor
      when :icc
        f1 = File.join(File.dirname(__FILE__), "assets", "icc-boilerplate.adoc")
        f2 = File.join(File.dirname(__FILE__), "assets", "icc-i18n.yaml")
        [":boilerplate-authority: #{f1}",
         ":i18nyaml: #{f2}",
         ":publisher: International Color Consortium",
         ":publisher_abbr: ICC"].each { |a| attrs << a }
        options[":boilerplate-authority:"] = f
      end
      attrs
    end
  end
end
