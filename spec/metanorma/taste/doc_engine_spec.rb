# frozen_string_literal: true

require "spec_helper"
require "metanorma/processor/processor"
require "metanorma/registry/registry"
require "zip"
require "rexml/document"

# A minimal presentation XML: bibdata-driven cover plus one section, one
# table, one figure.
PRESENTATION_XML = <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="presentation">
    <bibdata type="standard">
      <title language="en" type="main">Widget Test Document</title>
      <docidentifier primary="true">W100</docidentifier>
      <docnumber>100</docnumber>
      <date type="published"><on>2026-06</on></date>
      <edition>1.0</edition>
      <contributor>
        <role type="author"/>
        <organization><name>Widget Organization</name></organization>
      </contributor>
    </bibdata>
    <clause id="c1"><fmt-title depth="1" id="t1">Scope</fmt-title>
      <p id="p1">This document tests the doc engine.</p>
      <table id="tb1"><tr><th>H1</th></tr><tr><td>V1</td></tr></table>
      <figure id="f1"><fmt-name id="fn1">Fig 1</fmt-name></figure>
    </clause>
  </metanorma>
XML

# The taste-contributed output-engine override (metanorma-taste#251): a taste
# whose config declares `base-override.doc-engine` reroutes that format's
# output through the declared engine, via a module metanorma-taste prepends
# into the base flavor's Processor.
RSpec.describe Metanorma::Taste::DocEngine do
  let(:dummy_processor_class) do
    Class.new(Metanorma::Processor) do
      def initialize # rubocop:disable Lint/MissingSuper
        @short = :docengine_dummy
        @input_format = :asciidoc
      end

      # the base flavor's own pipeline, as the prepended chain's `super`
      def output(_isodoc_node, _inname, outname, _format, _options = {})
        File.write(outname, "legacy output")
      end
    end
  end

  let(:dummy_config) do
    Metanorma::Taste::TasteConfig.from_yaml(<<~YAML)
      flavor: docengine-taste
      base-flavor: docengine_dummy
      base-override:
        doc-engine: uniword
        value-attributes:
          output-extensions: xml,doc
    YAML
  end

  let(:orphan_config) do
    Metanorma::Taste::TasteConfig.from_yaml(<<~YAML)
      flavor: orphan-taste
      base-flavor: no_such_flavor
      base-override:
        doc-engine: uniword
        value-attributes:
          output-extensions: xml
    YAML
  end

  # The engine_for lookups read the shared TasteRegister and the real taste
  # configs; the install/prepend mutates the dummy class registered here,
  # which stays harmlessly in the registry (no Asciidoctor backend, so it
  # never participates in flavor resolution).
  before do
    Metanorma::Registry.instance.register(dummy_processor_class)
  end

  describe ".engine_for" do
    it "returns the declared engine for doc under the declaring taste" do
      expect(described_class.engine_for(:doc, supplied_type: :iala))
        .to eq(:uniword)
    end

    it "returns nil for formats the engine does not claim" do
      expect(described_class.engine_for(:html, supplied_type: :iala))
        .to be_nil
    end

    it "returns nil for tastes that declare no doc-engine" do
      expect(described_class.engine_for(:doc, supplied_type: :wmo))
        .to be_nil
    end

    it "returns nil without an active taste" do
      expect(described_class.engine_for(:doc, {})).to be_nil
    end
  end

  describe ".install" do
    it "prepends the Output module into the base flavor's processor" do
      described_class.install(dummy_config)
      expect(dummy_processor_class < described_class::Output).to be(true)
    end

    it "is idempotent" do
      2.times { described_class.install(dummy_config) }
      expect(dummy_processor_class.ancestors
        .count(described_class::Output)).to eq(1)
    end

    it "is a no-op when the base flavor has no registered processor" do
      expect { described_class.install(orphan_config) }.not_to raise_error
    end
  end

  describe "prepended Output#output" do
    # hold the Tempfile object itself: memoizing only its path would let
    # the file be collected and unlinked before the engine reads it
    let(:presentation_xml_file) do
      Tempfile.new(["presentation", ".xml"]).tap do |file|
        file.write(PRESENTATION_XML)
        file.close
      end
    end

    let(:presentation_xml_path) { presentation_xml_file.path }

    before { described_class.install(dummy_config) }

    it "renders the declared format through uniword" do
      run_engine_output(:doc, :iala)
      Zip::File.open(outname) { |zip| expect_uniword_package(zip) }
    end

    it "keeps the base flavor's own pipeline for other tastes" do
      run_engine_output(:doc, :wmo)
      expect(File.read(outname)).to eq("legacy output")
    end

    it "keeps the base flavor's own pipeline for other formats" do
      run_engine_output(:html, :iala)
      expect(File.read(outname)).to eq("legacy output")
    end

    # engine_for reads the real taste configs; :iala is the taste that
    # declares doc-engine: uniword
    def run_engine_output(format, supplied_type)
      processor.output(nil, presentation_xml_path, outname, format,
                       { supplied_type: supplied_type })
    end

    def processor
      Metanorma::Registry.instance.find_processor(:docengine_dummy)
    end

    def outname
      File.join(@docengine_outdir ||= Dir.mktmpdir("docengine"),
                "document.doc")
    end

    def expect_uniword_package(zip)
      expect(zip.find_entry("word/document.xml")).not_to be_nil
      expect_cover_texts(zip)
      expect_referenced_styles_defined(zip)
    end
  end

  def expect_cover_texts(zip)
    texts = document_xml(zip).elements.to_a("//w:t").map(&:text).join
    expect(texts).to include("W100")
    expect(texts).to include("Widget Organization")
    expect(texts).to include("Widget Test Document")
  end

  def expect_referenced_styles_defined(zip)
    refs = document_xml(zip).elements.to_a("//w:pStyle")
      .map { |e| e.attributes["w:val"] }
    expect(refs - defined_style_ids(zip)).to be_empty
  end

  def defined_style_ids(zip)
    REXML::Document.new(zip.read("word/styles.xml"))
      .elements.to_a("//w:style").map { |e| e.attributes["w:styleId"] }
  end

  def document_xml(zip)
    REXML::Document.new(zip.read("word/document.xml"))
  end
end
