# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Taste
    # Model for a single publisher bibliography sort-rank entry. A taste lists
    # these to override the base flavour's built-in publisher sort order for the
    # bibliography (e.g. OIML ranks OIML ahead of ISO/IEC). Each entry compiles
    # to a :sort-biblio-<abbrev>: <rank>: <name> document attribute, consumed by
    # the shared Metanorma::Standoc::Ref sort helpers.
    class BiblioSortItem < Lutaml::Model::Serializable
      attribute :abbrev, :string
      attribute :name, :string
      attribute :rank, :integer

      key_value do
        map "abbrev", to: :abbrev
        map "name", to: :name
        map "rank", to: :rank
      end
    end
  end
end
