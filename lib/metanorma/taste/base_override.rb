# frozen_string_literal: true

require "lutaml/model"
require_relative "filename_attributes"
require_relative "value_attributes"

module Metanorma
  module Taste
    # Model for base-override configuration
    # Contains nested filename-attributes and value-attributes
    class BaseOverride < Lutaml::Model::Serializable
      attribute :filename_attributes, FilenameAttributes
      attribute :value_attributes, ValueAttributes

      key_value do
        map "filename-attributes", to: :filename_attributes
        map "value-attributes", to: :value_attributes
      end
    end
  end
end
