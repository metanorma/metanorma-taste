module Metanorma
  class CustomAssets
    def initialize(flavor)
      @flavor = flavor
    end

    def process_input_adoc_overrides(attrs, options)
      case @flavor
      when :icc
        f = File.join(File.dirname(__FILE__), 'assets', 'icc-boilerplate.adoc')
        [":boilerplate-authority: #{f}",
         ':publisher: International Color Consortium',
         ':publisher_abbr: ICC'].each { |a| attrs << a }
        options[':boilerplate-authority:'] = f
      end
      attrs
    end
  end
end
