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
          # metanorma-core hosts the flavor/taste table; in contexts
          # without it (or with a released version predating the table),
          # tastes keep working unregistered.
          begin
            require "metanorma-core"
          rescue LoadError
            return
          end

          return unless defined?(Metanorma::Core::Flavors)

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

          Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
            name: taste,
            base_flavor: base,
            gem: "metanorma-taste",
            model_root: "Metanorma::#{camelize(base)}::Document::Root",
            publisher_abbr: abbrev,
            branding_dir: directory,
            doctype_map: doctype_map(config),
            renderers: {
              html: lambda do |document, **_options|
                next nil unless abbrev

                taste_publisher(document) == abbrev &&
                  base_renderer(base, document)
              end,
            },
          ))
        end

        def doctype_map(config)
          Array(config.doctypes).each_with_object({}) do |dt, map|
            taste_name = safe_read(dt, :taste)
            base_name = safe_read(dt, :base)
            map[taste_name.to_sym] = base_name.to_sym if taste_name && base_name
          end
        end

        def safe_read(obj, attr)
          return nil unless obj.is_a?(Lutaml::Model::Serializable)
          return nil unless obj.class.attributes.key?(attr)

          obj.public_send(attr)
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
          entry = Metanorma::Core::Flavors.find(base)
          entry&.renderer_for(:html, document)
        end

        def camelize(sym)
          sym.to_s.split(/[-_]/).map(&:capitalize).join
        end
      end
    end
  end
end
