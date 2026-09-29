Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# TEMPORARY pin: the flavor/taste table (metanorma-core#18) merged to main on
# 2026-09-06 but is unreleased (latest gem 0.2.3 predates it). Drop this pin
# once metanorma-core > 0.2.3 is on rubygems.
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
# TEMPORARY pin for the compile fix (implicit presentation dependency +
# non-mutating output_formats, metanorma#602, rebase-merged into
# feat/flavors-table); drop when that branch reaches rubygems.
gem "metanorma", github: "metanorma/metanorma", branch: "feat/flavors-table"

group :development do
  gem "canon"
  gem "debug"
  gem "equivalent-xml", "~> 0.6"
  gem "metanorma-cli"
  gem "metanorma-generic", ">= 3.4.0"
  gem "metanorma-ieee", ">= 1.6.8"
  gem "metanorma-iso", ">= 3.4.2"
  gem "metanorma-ribose", ">= 2.8.4"
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
