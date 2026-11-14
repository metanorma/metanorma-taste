# frozen_string_literal: true

require "fileutils"
require "metanorma"
require "yaml"

RSpec.describe "taste customization and the flavor registry" do
  # A taste whose customize metanorma.yml declared `metanorma_name`
  # minted a second, unusable processor into Metanorma::Registry
  # mid-compile: Generic::Converter#read_config_file re-registers
  # Metanorma::Generic::Processor after loading the customize config
  # (metanorma-generic#77), and the minted processor carried the
  # taste's name as its short name and Asciidoctor backend - a backend
  # no converter serves. The very next compile of that taste in the
  # same process then fatal-aborted with "missing converter for
  # backend '<taste>'". Collection/site builds compile every member in
  # one process, so any multi-document taste build died on its second
  # document. The customize metanorma.yml therefore declares no
  # metanorma_name: the taste keeps resolving to its base flavor, and
  # the customize config keeps configuring the base flavor's converter.
  let(:base_dir) { "spec/assets" }
  let(:base_name) { "test" }

  # Every taste that ships a customize metanorma.yml. This is the only
  # taste shape that drives the generic re-registration path.
  let(:customizing_tastes) do
    Metanorma::TasteRegister.instance.available_tastes.select do |taste|
      customize_filename(taste)
    end
  end

  def customize_filename(taste)
    Metanorma::TasteRegister.get_config(taste)&.base_override
      &.filename_attributes&.customize
  end

  def cleanup_files
    Dir.glob(File.join(base_dir, "#{base_name}.*"))
      .reject { |f| f.end_with?(".adoc") }
      .each { |f| FileUtils.rm_f(f) }
  end

  before { cleanup_files }
  after { cleanup_files }

  it "keeps metanorma_name out of every customize metanorma.yml" do
    expect(customizing_tastes).not_to be_empty

    customizing_tastes.each do |taste|
      path = File.expand_path(
        "../../data/#{taste}/#{customize_filename(taste)}", __dir__,
      )
      config = YAML.safe_load(File.read(path, encoding: "UTF-8"))
      # A metanorma_name here makes the generic re-registration mint a
      # processor named after the taste, whose Asciidoctor backend has
      # no converter (see the example description).
      expect(config).not_to include("metanorma_name")
    end
  end

  it "compiles each customizing taste repeatedly in one process" do
    expect(customizing_tastes).not_to be_empty

    customizing_tastes.each do |taste|
      2.times do
        compile = Metanorma::Compile.new
        expect do
          compile.compile(File.join(base_dir, "#{base_name}.adoc"),
                          type: taste.to_s, agree_to_terms: true)
        end.not_to raise_error
      end

      # The taste still resolves to its base flavor: no self-aliasing
      # processor was minted under the taste's own name.
      expect(Metanorma::Registry.instance.alias(taste)).to eq(
        Metanorma::TasteRegister.get_config(taste).base_flavor.to_sym,
      )
    end
  end
end
