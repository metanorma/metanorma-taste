require_relative "../spec_helper"

RSpec.describe Metanorma::Taste do
  describe ".aliases" do
    it "returns the correct mapping of flavors" do
      expect(described_class.aliases)
        .to eq({
                 csa: :generic,
                 elf: :iso,
                 enosema: :iso,
                 icc: :iso,
                 mbxif: :ribose,
                 oiml: :iso,
                 pdfa: :ribose,
                 swf: :ribose,
               })
    end
  end
end
