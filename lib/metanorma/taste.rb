# frozen_string_literal: true

require_relative "taste/base"
require_relative "taste_register"

module Metanorma
  module Taste
    # Taste-contributed output engines (see Taste::DocEngine).
    autoload :DocEngine, "metanorma/taste/doc_engine"
    autoload :UniwordDocRender, "metanorma/taste/uniword_doc_render"

    # Convenience method for aliases
    def self.aliases
      TasteRegister.instance.aliases
    end
  end
end

# Initialize the register on load
Metanorma::TasteRegister.instance
