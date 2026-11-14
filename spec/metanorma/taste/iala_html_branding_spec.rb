# frozen_string_literal: true

require "fileutils"
require "metanorma"

RSpec.describe "iala HTML branding" do
  # metanorma-taste#252: the iala HTML lane renders iala-branded
  # furniture — the taste's own coverpage and stylesheet replace the
  # iho base's IHO-branded assets. One compile for the group: the
  # compile pipeline is not re-runnable in-process.
  base_dir = "spec/assets"
  base_name = "test"

  before(:all) do
    Dir.glob(File.join(base_dir, "#{base_name}.*"))
      .reject { |f| f.end_with?(".adoc") }
      .each { |f| FileUtils.rm_f(f) }

    Metanorma::Compile.new.compile(
      File.join(base_dir, "#{base_name}.adoc"),
      type: "iala", agree_to_terms: true,
    )
    @html = File.read(File.join(base_dir, "#{base_name}.html"))
  end

  after(:all) do
    Dir.glob(File.join(base_dir, "#{base_name}.*"))
      .reject { |f| f.end_with?(".adoc") }
      .each { |f| FileUtils.rm_f(f) }
  end

  subject(:html) { @html }

  it "carries the IALA organisation on the cover" do
    expect(html).to include("International Organization for Marine " \
                            "Aids to Navigation")
  end

  it "renders the taste's coverpage, not the iho base's" do
    # iala titlepage markers
    expect(html).to include('class="coverpage-organisation"')
    expect(html).to include("IALA")
    # iho base titlepage markers are gone
    expect(html).not_to include("International Hydographic Organization")
    expect(html).not_to include("IHO ")
    expect(html).not_to include('class="wrapper-top"')
  end

  it "carries the IALA palette, not the IHO navy" do
    expect(html).to include("#00558C")
    expect(html).to include("#6787C4")
    expect(html).to include("#FEDB00")
    expect(html).not_to include("05164D")
    expect(html).not_to include("05164d")
  end

  it "embeds the IALA logo" do
    expect(html).to include('class="logo-img"')
    expect(html).to include("svg")
  end
end
