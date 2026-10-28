Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

gem "metanorma-core", "~> 0.2.5.pre.alpha" # published flavor/taste table (metanorma-core#18)
# TEMPORARY pin for the compile fix (implicit presentation dependency +
# non-mutating output_formats, metanorma#602, rebase-merged into
# feat/flavors-table); drop when that branch reaches rubygems.
gem "metanorma", github: "metanorma/metanorma", branch: "main"

group :development do
  gem "canon"
  gem "debug"
  gem "equivalent-xml", "~> 0.6"
  gem "metanorma", github: "metanorma/metanorma", branch: "main"
  gem "metanorma-cli", github: "metanorma/metanorma-cli", branch: "main"
  gem "metanorma-generic", github: "metanorma/metanorma-generic", branch: "main" # generic#130 merged
  gem "metanorma-ieee", github: "metanorma/metanorma-ieee", branch: "main"
  gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main" # released caps document at 0.2; oiml main needs 0.4+
  gem "metanorma-ribose", github: "metanorma/metanorma-ribose", branch: "main"
  gem "mnconvert"
  gem "pry"
  gem "rake", "~> 13.0"
  gem "rspec", "~> 3.0"
  gem "rspec-command", "~> 1.0"
  gem "rubocop", "~> 1"
  gem "rubocop-performance"
  gem "sassc-embedded", "~> 1"
  gem "simplecov", "~> 0.15"
end

begin
  eval_gemfile("Gemfile.devel")
rescue StandardError
  nil
end
gem "metanorma-oiml", github: "metanorma/metanorma-oiml", branch: "main" # oiml taste specs lazy-require the STS adapter (main-only, unreleased)
gem "relaton-iev", "2.0.2" # 2.0.1 and earlier cap relaton < 3, conflicting with the 3.x pre monogem
# released suma (all >= 0.2.6) pins svg_conform ~> 0.1.0, incompatible
# with standoc's ~> 0.2 (suma#127); main carries the fix
gem "suma", github: "metanorma/suma", branch: "main"
# released plugin-lutaml 0.7.50 dropped the preprocessor names standoc
# registers (LutamlDataPreprocessor); main carries them (generic#133)
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main"
# relaton 3.0.0 is released; the α-era exact pin sorts below it and
# conflicts with released metanorma-document's `relaton ~> 3.0` floor
gem "relaton", "~> 3.0"
gem "relaton-render", "~> 3.0"
# coherent core mains: the α relaton line needs them (released ones cap render at 1.x)
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
gem "isodoc", github: "metanorma/isodoc", branch: "main"
gem "isodoc-i18n", github: "metanorma/isodoc-i18n", branch: "main"
gem "metanorma-utils", github: "metanorma/metanorma-utils", branch: "main"
# the suite compiles these base flavors; released ones reference retired 1.x render APIs
gem "metanorma-iho", github: "metanorma/metanorma-iho", branch: "main"

# full flavor zoo on mains: the metagem's released-cap zoo pulls 1.x-render flavors (ogc 2.10 → Relaton::Render::Parse)
gem "metanorma-bipm", github: "metanorma/metanorma-bipm", branch: "main"
gem "metanorma-cc", github: "metanorma/metanorma-cc", branch: "main"
gem "metanorma-iec", github: "metanorma/metanorma-iec", branch: "main"
gem "metanorma-ieee", github: "metanorma/metanorma-ieee", branch: "main"
gem "metanorma-ietf", github: "metanorma/metanorma-ietf", branch: "main"
gem "metanorma-gb", github: "metanorma/metanorma-gb", branch: "main"
gem "metanorma-iho", github: "metanorma/metanorma-iho", branch: "main"
gem "metanorma-itu", github: "metanorma/metanorma-itu", branch: "main"
gem "metanorma-jis", github: "metanorma/metanorma-jis", branch: "main"
gem "metanorma-ogc", github: "metanorma/metanorma-ogc", branch: "main"
gem "metanorma-plateau", github: "metanorma/metanorma-plateau", branch: "main"
