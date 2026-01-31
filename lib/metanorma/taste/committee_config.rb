module Metanorma
  module Taste
    # Model for individual committee items
    class CommitteeItem < Lutaml::Model::Serializable
      attribute :name, :string
      attribute :abbrev, :string
      attribute :number, :string
      attribute :logo, :string

      key_value do
        map "name", to: :name
        map "abbrev", to: :abbrev
        map "number", to: :number
        map "logo", to: :logo
      end
    end

    # Model for a category with its items
    class CommitteeCategory < Lutaml::Model::Serializable
      attribute :category_key, :string
      attribute :items, CommitteeItem, collection: true
    end

    # Model that handles the hash of dynamic keys
    class Committees < Lutaml::Model::Serializable
      attribute :categories, CommitteeCategory, collection: true

      key_value do
        map to: :categories,
            root_mappings: {
              category_key: :key,
              items: :value,
            }
      end
    end
  end
end
