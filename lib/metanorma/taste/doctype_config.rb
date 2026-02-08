# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Taste
    # Model for individual doctype configuration
    class DoctypeConfig < Lutaml::Model::Serializable
      attribute :taste, :string
      attribute :base, :string
      attribute :abbrev, :string
      attribute :override_attributes, :hash, collection: true

      key_value do
        map "taste", to: :taste
        map "base", to: :base
        map "abbrev", to: :abbrev
        map "override-attributes", to: :override_attributes
      end
    end
  end
end
