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
        map "base-override", to: :base_override
        map "doctypes", to: :doctypes
      end
    end
  end
end
