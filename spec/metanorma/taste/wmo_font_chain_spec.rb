require_relative "../../spec_helper"
require "yaml"

# metanorma-taste#286: the WMO XSL names DejaVu Sans Mono in its monospace
# font-family chains, but the taste's fonts: provisioning list does not
# provision it, so FOP warns "doesn't exist" for every mono run it reaches.
# Every font a WMO chain names must be provisioned by the fonts: list or be
# a system face the chain may rely on.
RSpec.describe "WMO font-family chains" do # rubocop:disable RSpec/DescribeClass -- subject is data/wmo, not a class
  let(:wmo_dir) { File.expand_path("../../../data/wmo", __dir__) }

  # Faces resolved from the operating system, not fontist.
  let(:system_fonts) { ["Courier New", "Arial", "Calibri", "Cambria Math"] }

  let(:provisioned) do
    config = YAML.load_file(File.join(wmo_dir, "config.yaml"))
    config.dig("base-override", "value-attributes", "fonts").split(";")
      .map { |f| f.strip.downcase }
  end

  # Static names of every font-family chain in the sheet; the
  # $font_noto_sans_* variables are base-sheet Noto fallbacks and are not
  # part of the static text.
  let(:chains) do
    File.read(File.join(wmo_dir, "wmo.xsl"))
      .scan(%r{<xsl:attribute name="font-family">([^<]*)<})
      .flatten
  end

  let(:unprovisioned) do
    allowed = provisioned + system_fonts.map(&:downcase)
    chains.flat_map { |chain| chain.split(",") }
      .map(&:strip).reject(&:empty?).uniq
      .reject { |name| allowed.include?(name.downcase) }
  end

  it "finds the font-family chains in the WMO sheet" do
    expect(chains).not_to be_empty
  end

  it "names only provisioned or system fonts" do
    expect(unprovisioned).to be_empty,
                             "WMO font chains name faces the fonts: list " \
                             "does not provision: #{unprovisioned.join(', ')}"
  end
end
