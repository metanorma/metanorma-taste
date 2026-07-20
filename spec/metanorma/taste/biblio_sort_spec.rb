require_relative "../../spec_helper"
require "metanorma/taste/base"

RSpec.describe Metanorma::Taste::Base do
  describe "#add_bibliography_sort_overrides" do
    let(:test_directory) { "/path/to/test/directory" }
    let(:config) { Metanorma::Taste::TasteConfig.from_yaml(yaml_config) }
    let(:base) { described_class.new(:test, config, directory: test_directory) }

    context "with a bibliography-sort config" do
      let(:yaml_config) do
        <<~YAML
          flavor: test
          owner: Test Organization
          base-flavor: iso
          base-override:
            bibliography-sort:
            - abbrev: OIML
              rank: 1
              name: International Organization of Legal Metrology
            - abbrev: ISO
              rank: 2
              name: International Organization for Standardization
            - abbrev: IEC
              rank: 3
              name: International Electrotechnical Commission
        YAML
      end

      it "emits one :sort-biblio-<abbrev>: <rank>: <name> per publisher" do
        override_attrs = []
        base.send(:add_bibliography_sort_overrides, override_attrs)
        expect(override_attrs).to eq [
          ":sort-biblio-OIML: 1: International Organization of Legal Metrology",
          ":sort-biblio-ISO: 2: International Organization for Standardization",
          ":sort-biblio-IEC: 3: International Electrotechnical Commission",
        ]
      end
    end

    context "when bibliography-sort is absent" do
      let(:yaml_config) do
        <<~YAML
          flavor: test
          owner: Test Organization
          base-flavor: iso
        YAML
      end

      it "adds no override attributes" do
        override_attrs = []
        base.send(:add_bibliography_sort_overrides, override_attrs)
        expect(override_attrs).to be_empty
      end
    end
  end
end
