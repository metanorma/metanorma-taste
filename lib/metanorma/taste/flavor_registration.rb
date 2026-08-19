# frozen_string_literal: true

module Metanorma
  module Taste
    # Registers every discovered taste with the metanorma-document
    # flavor registry (Metanorma.flavors): a taste is a more-specific
    # entry over its base flavor, carrying the taste's branding
    # directory. The html renderer resolves to the BASE flavor's
    # renderer when the document's publisher matches the taste's
    # publisher abbreviation; otherwise the resolver yields nil and the
    # registry's most-specific-first walk falls through to the base
    # flavor's own entry. The base flavor's repo never changes.
    module FlavorRegistration
      class << self
        def register!
          # metanorma-document is the registry host; in compile-only
          # contexts without it, tastes keep working unregistered.
          begin
            require "metanorma/document"
          rescue LoadError
            return
          end

          TasteRegister.instance.available_tastes.each do |taste|
            register_taste(taste)
          end
        end

        private

        def register_taste(taste)
          config = TasteRegister.get_config(taste)
          base = config&.base_flavor&.to_sym
          return unless base

          abbrev = publisher_abbreviation(config)
          directory = TasteRegister.instance
                         .send(:config_directory_for, taste)

          Metanorma.register_flavor(Metanorma::Flavor.new(
                                      name: taste,
                                      model_class:
                                        "Metanorma::#{camelize(base)}::Document::Root",
                                      themes_dir: directory,
                                      renderers: {
                                        html: lambda do |document, **_options|
                                          next nil unless abbrev

                                          taste_publisher(document) == abbrev &&
                                            base_renderer(base, document)
                                        end,
                                      },
                                    ))
        end

        def publisher_abbreviation(config)
          attrs = config.base_override&.value_attributes
          return nil unless attrs

          attrs.publisher_abbr&.strip
        end

        # First author-publisher abbreviation on bibdata (the taste
        # discriminator), or nil.
        def taste_publisher(document)
          bibdata = document.bibdata if document.is_a?(Lutaml::Model::Serializable)
          return nil unless bibdata

          contributors = bibdata.contributor
          return nil unless contributors

          contributors.each do |c|
            roles = c.role
            next unless roles.is_a?(Array)
            next unless roles.any? { |r| r&.type == "author" }

            org = c.organization
            next unless org

            abbrev = org.abbreviation
            val = abbrev.is_a?(String) ? abbrev : abbrev.to_s
            return val unless val.empty?
          end
          nil
        end

        def base_renderer(base, document)
          base_flavor = Metanorma.flavors.find { |f| f.name == base }
          base_flavor&.renderer_for(:html, document)
        end

        def camelize(sym)
          sym.to_s.split(/[-_]/).map(&:capitalize).join
        end
      end
    end
  end
end
