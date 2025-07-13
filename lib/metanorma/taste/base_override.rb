# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Taste
    # Model for base-override configuration
    class BaseOverride < Lutaml::Model::Serializable
      attribute :publisher, :string
      attribute :publisher_abbr, :string
      attribute :body_font, :string
      attribute :header_font, :string
      attribute :monospace_font, :string
      attribute :presentation_metadata_color_secondary, :string
      attribute :presentation_metadata_backcover_text, :string

      key_value do
        map "publisher", to: :publisher
        map "publisher_abbr", to: :publisher_abbr
        map "body-font", to: :body_font
        map "header-font", to: :header_font
        map "monospace-font", to: :monospace_font
        map "presentation-metadata-color-secondary",
            to: :presentation_metadata_color_secondary
        map "presentation-metadata-backcover-text",
            to: :presentation_metadata_backcover_text
      end
    end
  end
end
