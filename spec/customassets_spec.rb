require "spec_helper"

RSpec.describe Metanorma::Taste do
  describe ".aliases" do
    it "returns the correct mapping of flavors" do
      expect(described_class.aliases).to eq({ icc: :iso })
    end
  end

  describe "#process_input_adoc_overrides" do
    let(:attrs) { [] }
    let(:options) { {} }

    context "with :icc flavor" do
      let(:taste) { described_class.new(:icc) }
      let(:expected_boilerplate_path) do
        # Use the same path construction logic as in the implementation
        File.join(
          File.dirname(Metanorma::Taste
          .instance_method(:process_input_adoc_overrides)
          .source_location.first), "assets", "icc-boilerplate.adoc"
        )
      end

      it "adds the correct attributes and updates options" do
        result = taste.process_input_adoc_overrides(attrs, options)

        # Check that the method returns the modified attrs array
        expect(result).to eq(attrs)

        # Check that the attrs array contains the expected values
        expect(attrs).to include(":boilerplate-authority: #{expected_boilerplate_path}")
        expect(attrs).to include(":publisher: International Color Consortium")
        expect(attrs).to include(":publisher_abbr: ICC")

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
    end

    context "with other flavor" do
      let(:taste) { described_class.new(:other) }

      it "does not modify the attributes or options" do
        original_attrs = attrs.dup
        original_options = options.dup

        result = taste.process_input_adoc_overrides(attrs, options)

        # Check that the method returns the unmodified attrs array
        expect(result).to eq(original_attrs)

        # Check that the attrs array is not modified
        expect(attrs).to eq(original_attrs)

        # Check that the options hash is not modified
        expect(options).to eq(original_options)
      end
    end
  end
end
