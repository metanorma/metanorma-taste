require_relative "../../spec_helper"

RSpec.describe Metanorma::Taste::UrnGenerator do
  describe ".register and .generate" do
    after do
      described_class.registry.delete(:spec_test_gen)
    end

    it "runs the registered generator over the attributes" do
      described_class.register(:spec_test_gen) do |attrs|
        "urn:x:#{attrs['docnumber']}"
      end

      expect(described_class.generate(:spec_test_gen, { "docnumber" => "42" }))
        .to eq("urn:x:42")
    end

    it "resolves hyphenated config names to underscored registrations" do
      described_class.register(:spec_test_gen) { |_attrs| "urn:x:y" }

      expect(described_class.generate("spec-test-gen", {})).to eq("urn:x:y")
    end

    it "raises UnknownGeneratorError for an unregistered name" do
      expect { described_class.generate(:no_such_generator, {}) }
        .to raise_error described_class::UnknownGeneratorError
    end
  end

  describe "#generate with the iala taste's pubid-iala shim" do
    # The iala taste's urn-generator: bibdata URNs are generated through
    # Pubid::Iala from the identifier fields (series + docnumber +
    # edition); pubid is the identifier SSOT (metanorma-taste#250).
    let(:shim_path) do
      config = Metanorma::TasteRegister.get_config("iala")
      File.join(config.directory, "urn_generator.rb")
    end

    let(:g1199_attrs) do
      { "series" => "G", "docnumber" => "1199", "edition" => "1.0" }
    end

    def generate(attrs)
      described_class.generate("pubid-iala", attrs)
    end

    before do
      require shim_path
    end

    it "generates the published URN form for the g1199 identifier fields" do
      expect(generate(g1199_attrs)).to eq("urn:mrn:iala:pub:g1199:ed1.0")
    end

    it "equals the Pubid::Iala output for the printed identifier" do
      parsed = Pubid::Iala::Identifier.parse("IALA G1199 Ed 1.0").to_urn
      expect(generate(g1199_attrs)).to eq(parsed)
    end

    it "canonicalizes non-canonical numbers through pubid" do
      attrs = { "series" => "G", "docnumber" => "119", "edition" => "1.0" }
      expect(generate(attrs)).to eq("urn:mrn:iala:pub:g0119:ed1.0")
    end

    it "omits the edition segment when the document has no edition" do
      expect(generate({ "series" => "S", "docnumber" => "1070" }))
        .to eq("urn:mrn:iala:pub:s1070")
    end

    it "falls back to seriesabbr when series is absent" do
      expect(generate({ "seriesabbr" => "S", "docnumber" => "1070" }))
        .to eq("urn:mrn:iala:pub:s1070")
    end

    it "emits nothing for documents without an IALA series letter" do
      expect(generate({ "docnumber" => "1199" })).to be_nil
    end

    it "emits nothing for series letters pubid does not know" do
      expect(generate({ "series" => "Z", "docnumber" => "1199" })).to be_nil
    end
  end
end
