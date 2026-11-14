require_relative "../../spec_helper"
require "metanorma/taste/base"

RSpec.describe Metanorma::Taste::Base do
  describe "#add_urn_generation_overrides" do
    let(:test_directory) { File.expand_path("../../assets", __dir__) }
    let(:config) do
      Metanorma::Taste::TasteConfig.from_yaml(yaml_config)
    end
    let(:base) do
      described_class.new(:test, config, directory: test_directory)
    end

    let(:attrs) do
      [":doctype: standard", ":series: G", ":docnumber: 1199", ":edition: 1.0"]
    end

    before do
      described = Metanorma::Taste::UrnGenerator
      described.register(:spec_test_gen) do |document_attrs|
        next unless document_attrs["series"] && document_attrs["docnumber"]

        "urn:x-gen:#{document_attrs['series']}#{document_attrs['docnumber']}"
      end
    end

    after do
      Metanorma::Taste::UrnGenerator.registry.delete(:spec_test_gen)
    end

    context "with a urn-generator config" do
      let(:yaml_config) do
        <<~YAML
          flavor: test
          owner: Test Organization
          base-flavor: iso
          base-override:
            urn-generator: spec_test_gen
        YAML
      end

      it "emits the generated URN as the :urn: attribute" do
        override_attrs = []
        base.send(:add_urn_generation_overrides, override_attrs, attrs)
        expect(override_attrs).to eq [":urn: urn:x-gen:G1199"]
      end

      it "keeps the document's explicit :urn: (transcription fallback wins)" do
        override_attrs = []
        explicit = attrs + [":urn: urn:mrn:custom-printed-form"]
        base.send(:add_urn_generation_overrides, override_attrs, explicit)
        expect(override_attrs).to be_empty
      end

      it "emits nothing when the document lacks the identifier fields" do
        override_attrs = []
        base.send(:add_urn_generation_overrides, override_attrs,
                  [":doctype: standard"])
        expect(override_attrs).to be_empty
      end
    end

    context "when urn-generator is absent" do
      let(:yaml_config) do
        <<~YAML
          flavor: test
          owner: Test Organization
          base-flavor: iso
        YAML
      end

      it "adds no :urn: attribute" do
        override_attrs = []
        base.send(:add_urn_generation_overrides, override_attrs, attrs)
        expect(override_attrs).to be_empty
      end
    end

    context "when the generator name is not registered" do
      let(:yaml_config) do
        <<~YAML
          flavor: test
          owner: Test Organization
          base-flavor: iso
          base-override:
            urn-generator: never_registered_gen
        YAML
      end

      it "propagates the UnknownGeneratorError" do
        override_attrs = []
        expect do
          base.send(:add_urn_generation_overrides, override_attrs, attrs)
        end.to raise_error Metanorma::Taste::UrnGenerator::UnknownGeneratorError
      end
    end

    describe "#document_attributes" do
      let(:yaml_config) do
        <<~YAML
          flavor: test
          owner: Test Organization
          base-flavor: iso
        YAML
      end

      it "lowercases attribute names and strips values" do
        expect(base.send(:document_attributes,
                         [":DocNumber: 1199", ":flag:", ":x:  spaced  "]))
          .to eq("docnumber" => "1199", "flag" => "", "x" => "spaced")
      end
    end
  end
end
