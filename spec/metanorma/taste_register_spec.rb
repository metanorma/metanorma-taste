require_relative "../spec_helper"

RSpec.describe Metanorma::TasteRegister do
  let(:register) { described_class.instance }

  describe "#available_tastes" do
    it "returns available tastes" do
      expect(register.available_tastes).to include(:icc)
    end
  end

  describe "#get_config" do
    it "returns taste information" do
      info = register.get_config(:icc)
      expect(info).to be_a(Metanorma::Taste::TasteConfig)
      expect(info.flavor).to eq("icc")
      expect(info.owner).to eq("International Color Consortium")
      expect(info.base_flavor).to eq("iso")
      expect(info.base_override.value_attributes.publisher).to eq("International Color Consortium")
      expect(info.doctypes.first.taste).to eq("specification")
      expect(info.doctypes.first.base).to eq("international-standard")
      expect(info.directory).to end_with(File.join("data", "icc"))
    end
  end

  describe "#isodoc_attrs" do
    it "returns isodoc attributes" do
      dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "data"))
      info = register.isodoc_attrs(:csa, :html).compact.transform_values do |v|
        v.is_a?(String) && File.exist?(v) ? File.expand_path(v) : v
      end
      expect(info).to eq({
                           bodyfont: "Lato,\"Source Sans Pro\",sans-serif",
                           datauriimage: true,
                           headerfont: "Lato,\"Source Sans Pro\",sans-serif",
                           htmlcoverpage: "#{dir}/csa/html_csa_titlepage.html",
                           htmlintropage: "#{dir}/csa/html_csa_intro.html",
                           htmlstylesheet: "#{dir}/csa/htmlstyle.scss",
                           monospacefont: "\"Source Code Pro\",monospace",
                           sourcehighlighter: true,
                           suppressasciimathdup: false,
                         })
      info = register.isodoc_attrs(:csa, :pdf).compact.transform_values do |v|
        v.is_a?(String) && File.exist?(v) ? File.expand_path(v) : v
      end
      expect(info).to eq({ pdfstylesheet: "#{dir}/csa/csa.standard.xsl" })
      info = register.isodoc_attrs(:csa, :doc).compact.transform_values do |v|
        v.is_a?(String) && File.exist?(v) ? File.expand_path(v) : v
      end
      expect(info).to eq({ bodyfont: "Lato,\"Source Sans Pro\",sans-serif",
                           header: "#{dir}/csa/header.html",
                           headerfont: "Lato,\"Source Sans Pro\",sans-serif",
                           monospacefont: "\"Source Code Pro\",monospace",
                           standardstylesheet: "#{dir}/csa/csa.scss",
                           wordcoverpage: "#{dir}/csa/word_csa_titlepage.html",
                           wordintropage: "#{dir}/csa/word_csa_intro.html",
                           wordstylesheet: "#{dir}/csa/wordstyle.scss" })
      info = register.isodoc_attrs(:csa, :presentation).compact.transform_values do |v|
        v.is_a?(String) && File.exist?(v) ? File.expand_path(v) : v
      end
      expect(info).to eq({})
    end
  end

  describe "#get" do
    it "returns a taste instance" do
      taste = register.get(:icc)
      expect(taste).to be_a(Metanorma::Taste::Base)
      expect(taste.flavor).to eq(:icc)
    end

    it "returns a dynamically created class" do
      taste = register.get(:icc)
      expect(taste).to be_a(Metanorma::Taste::Icc)
      expect(taste.class.to_s).to eq("Metanorma::Taste::Icc")
    end

    it "caches taste instances" do
      taste1 = register.get(:icc)
      taste2 = register.get(:icc)
      expect(taste1).to be(taste2)
    end

    it "raises an error for unknown taste" do
      expect do
        register.get(:unknown)
      end.to raise_error(Metanorma::TasteRegister::UnknownTasteError, "Unknown taste: unknown")
    end
  end

  describe "#validate_taste_config!" do
    let(:register) { described_class.instance }
    let(:valid_base_override) do
      Metanorma::Taste::BaseOverride.new.tap do |bo|
        bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
          va.output_extensions = "html,pdf,doc"
          va.publisher = "Test Publisher"
        end
      end
    end
    let(:valid_config) do
      Metanorma::Taste::TasteConfig.new.tap do |config|
        config.flavor = "test"
        config.base_override = valid_base_override
      end
    end

    context "when base-override.output-extensions is present" do
      it "passes validation" do
        expect do
          register.send(:validate_taste_config!, valid_config, "test")
        end.not_to raise_error
      end
    end

    context "when base-override is missing" do
      it "raises InvalidTasteConfigError" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = nil
        end

        expect do
          register.send(:validate_taste_config!, config, "test")
        end.to raise_error(
          Metanorma::TasteRegister::InvalidTasteConfigError,
          "Taste must have base-override.value-attributes.output-extensions defined",
        )
      end
    end

    context "when output-extensions is missing from base-override" do
      it "raises InvalidTasteConfigError" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.publisher = "Test Publisher"
              va.output_extensions = nil
            end
          end
        end

        expect do
          register.send(:validate_taste_config!, config, "test")
        end.to raise_error(
          Metanorma::TasteRegister::InvalidTasteConfigError,
          "Taste must have base-override.value-attributes.output-extensions defined",
        )
      end
    end

    context "when output-extensions is empty" do
      it "raises InvalidTasteConfigError" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.publisher = "Test Publisher"
              va.output_extensions = ""
            end
          end
        end

        expect do
          register.send(:validate_taste_config!, config, "test")
        end.to raise_error(
          Metanorma::TasteRegister::InvalidTasteConfigError,
          "Taste must have base-override.value-attributes.output-extensions defined",
        )
      end
    end

    context "when output-extensions is only whitespace" do
      it "raises InvalidTasteConfigError" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.publisher = "Test Publisher"
              va.output_extensions = "   \n\t  "
            end
          end
        end

        expect do
          register.send(:validate_taste_config!, config, "test")
        end.to raise_error(
          Metanorma::TasteRegister::InvalidTasteConfigError,
          "Taste must have base-override.value-attributes.output-extensions defined",
        )
      end
    end

    context "when flavor is missing" do
      it "raises InvalidTasteConfigError for missing flavor" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = nil
          c.base_override = valid_base_override
        end

        expect do
          register.send(:validate_taste_config!, config, nil)
        end.to raise_error(
          Metanorma::TasteRegister::InvalidTasteConfigError,
          "Taste must have a flavor name",
        )
      end
    end

    context "auto-enhancement of output-extensions" do
      it "adds 'presentation' when xml and html/doc/pdf are present but presentation is missing" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = "xml,html,pdf,doc"
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("xml,html,pdf,doc,presentation")
      end

      it "adds 'presentation' when xml and html are present but presentation is missing" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = "xml,html"
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("xml,html,presentation")
      end

      it "adds 'presentation' when xml and doc are present but presentation is missing" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = "xml,doc"
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("xml,doc,presentation")
      end

      it "adds 'presentation' when xml and pdf are present but presentation is missing" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = "xml,pdf"
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("xml,pdf,presentation")
      end

      it "does not add 'presentation' when it already exists" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = "xml,html,pdf,presentation"
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("xml,html,pdf,presentation")
      end

      it "does not add 'presentation' when xml is missing" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = "html,pdf,doc"
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("html,pdf,doc")
      end

      it "does not add 'presentation' when xml exists but no html/doc/pdf" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = "xml,rxl"
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("xml,rxl")
      end

      it "handles whitespace in extensions correctly" do
        config = Metanorma::Taste::TasteConfig.new.tap do |c|
          c.flavor = "test"
          c.base_override = Metanorma::Taste::BaseOverride.new.tap do |bo|
            bo.value_attributes = Metanorma::Taste::ValueAttributes.new.tap do |va|
              va.output_extensions = " xml , html , pdf "
            end
          end
        end

        register.send(:validate_taste_config!, config, "test")

        expect(config.base_override.value_attributes.output_extensions).to eq("xml,html,pdf,presentation")
      end
    end
  end

  describe "#process_input_adoc_overrides" do
    let(:attrs) { [":doctype: specification"] }
    let(:options) { {} }
    let(:taste) { described_class.get(:icc) }

    let(:expected_boilerplate_path) do
      # Get the actual path from the taste info
      info = described_class.instance.get_config(:icc)
      File.join(info.directory, info.base_override.filename_attributes.copyright_notice)
    end
    let(:expected_i18n_path) do
      info = described_class.instance.get_config(:icc)
      File.join(info.directory, info.base_override.filename_attributes.i18n_dictionary)
    end
    let(:expected_logo_path) do
      info = described_class.instance.get_config(:icc)
      File.join(info.directory, info.base_override.filename_attributes.publisher_logo)
    end
    let(:expected_htmlcoverpage) do
      info = described_class.instance.get_config(:icc)
      File.join(info.directory, info.base_override.filename_attributes.htmlcoverpage)
    end
    let(:expected_htmlstylesheet_override) do
      info = described_class.instance.get_config(:icc)
      File.join(info.directory, info.base_override.filename_attributes.htmlstylesheet_override)
    end

    it "adds the correct attributes and updates options" do
      result = taste.process_input_adoc_overrides(attrs, options)

      # Check that the method returns the modified attrs array
      expect(result).to eq(attrs)

      # Check that the attrs array contains the expected values
      expect(attrs).to include(":boilerplate-authority: #{expected_boilerplate_path}")
      expect(attrs).to include(":i18nyaml: #{expected_i18n_path}")
      expect(attrs).to include(":publisher_logo: #{expected_logo_path}")
      expect(attrs).to include(":htmlcoverpage: #{expected_htmlcoverpage}")
      expect(attrs).to include(":htmlstylesheet-override: #{expected_htmlstylesheet_override}")
      expect(attrs).to include(":publisher: International Color Consortium")
      expect(attrs).to include(":publisher_abbr: ICC")
      expect(attrs).to include(":body-font: Arial, 'Helvetica Neue', Helvetica, sans-serif")
      expect(attrs).to include(":header-font: Arial, 'Helvetica Neue', Helvetica, sans-serif")
      expect(attrs).to include(":presentation-metadata-color-secondary: #376795")
      expect(attrs).to include(":presentation-metadata-backcover-text: color.org")
      expect(attrs).to include(":doctype: international-standard")
      expect(attrs).to include(":presentation-metadata-doctype-alias: specification")

      # Check that the options hash is updated
      expect(options[":boilerplate-authority:"]).to eq(expected_boilerplate_path)
    end

    it "generates output with the correct boilerplate path" do
      taste.process_input_adoc_overrides(attrs, options)

      # Verify the boilerplate file exists
      expect(File.exist?(expected_boilerplate_path)).to be true

      # Verify the boilerplate file contains expected content
      boilerplate_content = File.read(expected_boilerplate_path)
      expect(boilerplate_content)
        .to include("Copyright (c) {{ docyear }} International Color Consortium")
      expect(boilerplate_content)
        .to include("International Color Consortium and the ICC logo are registered trademarks")
      expect(boilerplate_content)
        .to include("Visit the ICC Web site: http://www.color.org")
    end

    it "processes additive attributes correctly" do
       fonts = "D050000L;TeXGyreTermes;STIX Two Math;FreeSerif;FreeSans;Source Sans 3"
       attrs = [":fonts: #{fonts}"]
       taste = described_class.get(:pdfa)
       result = taste.process_input_adoc_overrides(attrs, {})
       expect(result).to include(":fonts: Source Sans Pro;#{fonts}")
    end
  end
end
