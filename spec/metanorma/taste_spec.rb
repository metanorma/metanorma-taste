require_relative "../spec_helper"

RSpec.describe Metanorma::Taste do
  describe ".aliases" do
    it "returns the correct mapping of flavors" do
      expect(described_class.aliases)
        .to eq({
                 csa: :generic,
                 elf: :iso,
                 enosema: :iso,
                 iala: :iho,
                 icc: :iso,
                 mbxif: :ribose,
                 oiml: :iso,
                 "oiml-cs": :iso,
                 pdfa: :ribose,
                 swf: :ribose,
                 wmo: :iho,
               })
    end
  end
end
