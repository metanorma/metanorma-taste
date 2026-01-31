module Metanorma
  module Taste
    # Model for individual committee items
    class CommitteeItem < Lutaml::Model::Serializable
      attribute :name, :string
      attribute :abbrev, :string
      attribute :number, :string
      attribute :logo, :string
      attribute :category, :string

      key_value do
        map "name", to: :name
        map "abbrev", to: :abbrev
        map "number", to: :number
        map "logo", to: :logo
        map "category", to: :category
      end
    end

    # Model for committees as a simple collection
    class Committees < Lutaml::Model::Serializable
      attribute :items, CommitteeItem, collection: true

      key_value do
        map to: :items
      end
    end
  end
end
