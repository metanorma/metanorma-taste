require_relative "../spec_helper"

RSpec.describe Metanorma::Taste do
  describe ".aliases" do
    it "returns the correct mapping of flavors" do
      expect(described_class.aliases).to eq({
        dsa: :iso,
        elf: :iso,
        enosema: :iso,
        icc: :iso
      })
    end
  end
end
