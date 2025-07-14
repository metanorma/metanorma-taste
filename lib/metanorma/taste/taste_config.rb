# frozen_string_literal: true

require "lutaml/model"
require_relative "base_override"
require_relative "doctype_config"

module Metanorma
  module Taste
    # Main configuration model
    class TasteConfig < Lutaml::Model::Serializable
      attribute :flavor, :string
      attribute :owner, :string
      attribute :base_flavor, :string
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
      attribute :pdfstylesheet, :string
      attribute :pdfstylesheet_override, :string
      attribute :base_override, BaseOverride
      attribute :doctypes, DoctypeConfig, collection: true
      attribute :directory, :string

      key_value do
        map "flavor", to: :flavor
        map "owner", to: :owner
        map "base-flavor", to: :base_flavor
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
        map "pdfstylesheet", to: :pdfstylesheet
        map "pdfstylesheet-override", to: :pdfstylesheet_override
        map "base-override", to: :base_override
        map "doctypes", to: :doctypes
      end
    end
  end
end
