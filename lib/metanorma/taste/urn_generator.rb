# frozen_string_literal: true

module Metanorma
  module Taste
    # Registry of bibdata-URN generators contributed by tastes.
    #
    # A taste declares a generator by name in its config
    # (+base-override.urn-generator+, e.g. +urn-generator: pubid-iala+)
    # and provides the implementation in an optional
    # +data/<taste>/urn_generator.rb+ shim, which calls {.register} on
    # load. The shim is required lazily on the generator's first use, so
    # the artefact gem it needs (e.g. pubid) loads only for builds that
    # use the generator; metanorma-taste carries no dependency on it.
    #
    # A generator receives the document's header attributes as a
    # lowercased name => value hash and returns the URN string, or nil
    # when the document lacks the identifier fields the generator needs
    # (no URN is then emitted, and the base flavor's urn propagation
    # stays inert).
    module UrnGenerator
      # Raised when the taste config names a generator no shim registered.
      class UnknownGeneratorError < StandardError; end

      # Raised when the generator's artefact gem cannot be loaded.
      class GeneratorLoadError < StandardError; end

      def self.register(name, &block)
        registry[normalized_name(name)] = block
      end

      # Run the named generator over +attrs+.
      #
      # @param name [String, Symbol] the +urn-generator+ config value
      # @param attrs [Hash{String => String}] document header attributes
      # @return [String, nil] the URN, or nil when the document lacks the
      #   fields the generator needs
      # @raise [UnknownGeneratorError] when +name+ is not registered
      def self.generate(name, attrs)
        block = registry[normalized_name(name)] or
          raise UnknownGeneratorError,
                "Unknown urn-generator: #{name} (its data/<taste>/" \
                "urn_generator.rb shim did not register it)"
        block.call(attrs)
      end

      def self.registry
        @registry ||= {}
      end

      # Config names are hyphenated ("pubid-iala"); Ruby identifiers in
      # shims are underscored. Both spellings resolve to one key.
      def self.normalized_name(name)
        name.to_s.tr("-", "_").to_sym
      end
    end
  end
end
