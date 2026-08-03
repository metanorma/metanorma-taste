# frozen_string_literal: true

require "lutaml/model"
require_relative "filename_attributes"
require_relative "value_attributes"
require_relative "biblio_sort_item"

module Metanorma
  module Taste
    # Model for base-override configuration
    # Contains nested filename-attributes and value-attributes
    class BaseOverride < Lutaml::Model::Serializable
      attribute :filename_attributes, FilenameAttributes
      attribute :value_attributes, ValueAttributes
      attribute :bibliography_sort, BiblioSortItem, collection: true

      key_value do
        map "filename-attributes", to: :filename_attributes
        map "value-attributes", to: :value_attributes
        map "bibliography-sort", to: :bibliography_sort
      end
    end
  end
end
