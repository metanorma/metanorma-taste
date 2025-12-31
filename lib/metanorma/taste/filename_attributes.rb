# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Taste
    # Model for filename-based attributes configuration
    # These are Metanorma document attributes that contain filenames
    class FilenameAttributes < Lutaml::Model::Serializable
      attribute :copyright_notice, :string
      attribute :i18n_dictionary, :string
      attribute :publisher_logo, :string
      attribute :htmlcoverpage, :string
      attribute :htmlintropage, :string
      attribute :htmlstylesheet, :string
      attribute :htmlstylesheet_override, :string
      attribute :wordcoverpage, :string
      attribute :wordintropage, :string
      attribute :wordstylesheet, :string
      attribute :wordstylesheet_override, :string
      attribute :header, :string
      attribute :standardstylesheet, :string
      attribute :standardstylesheet_override, :string
      attribute :pdfstylesheet, :string
      attribute :pdfstylesheet_override, :string
      attribute :customize, :string
      attribute :coverpage_image, :string
      attribute :backpage_image, :string
      attribute :coverpage_pdf_portfolio, :string

      key_value do
        map "copyright-notice", to: :copyright_notice
        map "i18n-dictionary", to: :i18n_dictionary
        map "publisher-logo", to: :publisher_logo
        map "htmlcoverpage", to: :htmlcoverpage
        map "htmlintropage", to: :htmlintropage
        map "htmlstylesheet", to: :htmlstylesheet
        map "htmlstylesheet-override", to: :htmlstylesheet_override
        map "wordcoverpage", to: :wordcoverpage
        map "wordintropage", to: :wordintropage
        map "wordstylesheet", to: :wordstylesheet
        map "wordstylesheet-override", to: :wordstylesheet_override
        map "standardstylesheet", to: :standardstylesheet
        map "standardstylesheet-override", to: :standardstylesheet_override
        map "header", to: :header
        map "pdf-stylesheet", to: :pdfstylesheet
        map "pdf-stylesheet-override", to: :pdfstylesheet_override
        map "customize", to: :customize
        map "coverpage-image", to: :coverpage_image
        map "backpage-image", to: :backpage_image
        map "coverpage-pdf-portfolio", to: :coverpage_pdf_portfolio
      end
    end
  end
end
