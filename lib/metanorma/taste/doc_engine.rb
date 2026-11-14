# frozen_string_literal: true

module Metanorma
  module Taste
    # Output-engine override contributed by tastes.
    #
    # A taste declares an engine for the Word output with
    # `base-override.doc-engine` in its config.yaml (e.g. `doc-engine:
    # uniword`). When the taste is first used, metanorma-taste prepends
    # {DocEngine::Output} into the base flavor's Processor class, so the
    # declared format is intercepted before the base flavor's own dispatch
    # runs; every other format, and every build without an active taste,
    # is unaffected.
    #
    # The `uniword` engine produces the Word output as an OOXML package: the
    # presentation XML is rendered by {UniwordDocRender} through uniword's
    # Builder API and written as a DOCX package. The output keeps the
    # flavor's `doc` format symbol and file extension, so builds that request
    # `doc` keep working unchanged; the bytes are the uniword DOCX package.
    # (Per the uniword ruling, metanorma-iso#1728: uniword is the only DOCX
    # engine; the isodoc MHTML artifact retires as an end-product.)
    #
    # uniword is required at use time only: the gem is needed by the tastes
    # that declare the engine (the samples bundles pin it), and
    # metanorma-taste carries no hard dependency on it.
    module DocEngine
      # The prepended Processor methods. `super` from {Output#output} is the
      # base flavor's own `#output`, keeping the base flavor fully in charge
      # of every format the engine does not claim.
      module Output
        def output(isodoc_node, inname, outname, format, options = {})
          if Taste::DocEngine.engine_for(format, options) == :uniword
            Taste::DocEngine.uniword_docx(inname, outname, options)
            return
          end
          super
        end
      end

      # Prepend {Output} into the base flavor's Processor class. No-op when
      # the base flavor has no registered processor (metanorma-taste
      # consumed without the compile stack), and idempotent.
      #
      # @param config [TasteConfig] the taste's configuration
      # @return [void]
      def self.install(config)
        klass = processor_class(config.base_flavor) or return
        return if klass < Output

        klass.prepend(Output)
      end

      # The engine the active taste declares for +format+, or nil to keep
      # the base flavor's own pipeline. Only the `doc` format is engine-
      # dispatched today. The active taste rides the compile options as
      # +:supplied_type+.
      #
      # @param format [Symbol] output format
      # @param options [Hash] processor options
      # @return [Symbol, nil]
      def self.engine_for(format, options)
        return nil unless format == :doc

        taste = options[:supplied_type] or return nil
        config = Metanorma::TasteRegister.get_config(taste) or return nil
        config.base_override&.doc_engine&.to_sym
      end

      # Render the presentation XML at +inname+ to a DOCX package at
      # +outname+ through uniword. The presentation XML is the input the
      # compile driver hands every Word-format leg (doc output is
      # downstream of the presentation stage).
      #
      # @param inname [String] presentation XML path
      # @param outname [String] output path (DOCX package bytes)
      # @param options [Hash] processor options (unused; reserved)
      def self.uniword_docx(inname, outname, _options = {})
        require "uniword"
        Metanorma::Taste::UniwordDocRender
          .new(File.read(inname, encoding: "UTF-8"))
          .save(outname)
      end

      # The registered Processor class of +base_flavor+, or nil.
      def self.processor_class(base_flavor)
        return unless defined?(Metanorma::Registry)

        Metanorma::Registry.instance.find_processor(base_flavor)&.class
      end
    end
  end
end
