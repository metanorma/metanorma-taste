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
      attribute :presentation_metadata_ul_label_list, :string
      attribute :presentation_metadata_annex_delim, :string
      attribute :presentation_metadata_middle_title, :string
      attribute :presentation_metadata_ol_label_template_alphabet, :string
      attribute :presentation_metadata_ol_label_template_alphabet_upper, :string
      attribute :presentation_metadata_ol_label_template_roman, :string
      attribute :presentation_metadata_ol_label_template_roman_upper, :string
      attribute :presentation_metadata_ol_label_template_arabic, :string
      attribute :fonts, :string
      attribute :pdf_stylesheet_override, :string
      attribute :output_extensions, :string

      key_value do
        map "publisher", to: :publisher
        map "publisher_abbr", to: :publisher_abbr
        map "body-font", to: :body_font
        map "header-font", to: :header_font
        map "monospace-font", to: :monospace_font
        map "fonts", to: :fonts
        map "presentation-metadata-color-secondary",
            to: :presentation_metadata_color_secondary
        map "presentation-metadata-backcover-text",
            to: :presentation_metadata_backcover_text
        map "presentation-metadata-ul-label-list",
            to: :presentation_metadata_ul_label_list
        map "presentation-metadata-annex-delim",
            to: :presentation_metadata_annex_delim
        map "presentation-metadata-middle-title",
            to: :presentation_metadata_middle_title
        map "presentation-metadata-ol-label-template-alphabet",
            to: :presentation_metadata_ol_label_template_alphabet
        map "presentation-metadata-ol-label-template-alphabet_upper",
            to: :presentation_metadata_ol_label_template_alphabet_upper
        map "presentation-metadata-ol-label-template-roman",
            to: :presentation_metadata_ol_label_template_roman
        map "presentation-metadata-ol-label-template-roman_upper",
            to: :presentation_metadata_ol_label_template_roman_upper
        map "presentation-metadata-ol-label-template-arabic",
            to: :presentation_metadata_ol_label_template_arabic
        map "fonts", to: :fonts
        map "pdf-stylesheet-override", to: :pdf_stylesheet_override
        map "output-extensions", to: :output_extensions
      end
    end
  end
end
