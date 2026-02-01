# frozen_string_literal: true

require "lutaml/model"
require_relative "base_override"
require_relative "doctype_config"
require_relative "stage_config"
require_relative "committee_config"

module Metanorma
  module Taste
    # Main configuration model
    class TasteConfig < Lutaml::Model::Serializable
      attribute :flavor, :string
      attribute :owner, :string
      attribute :base_flavor, :string
      attribute :base_override, BaseOverride
      attribute :doctypes, DoctypeConfig, collection: true
      attribute :stages, StageConfig, collection: true
      attribute :committees, CommitteeItem, collection: true
      attribute :directory, :string

      key_value do
        map "flavor", to: :flavor
        map "owner", to: :owner
        map "base-flavor", to: :base_flavor
        map "base-override", to: :base_override
        map "doctypes", to: :doctypes
        map "stages", to: :stages
        map "committees", to: :committees
      end
    end
  end
end
