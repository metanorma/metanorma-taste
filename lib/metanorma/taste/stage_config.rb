# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Taste
    # Model for individual stage configuration
    class StageConfig < Lutaml::Model::Serializable
      attribute :default, :string
      attribute :published, :string
      attribute :abbreviation, :string

      key_value do
        map "default", to: :default
        map "published", to: :published
        map "abbreviation", to: :abbreviation
      end
    end
  end
end
