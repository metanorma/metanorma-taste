Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

group :development do
  gem "canon", "= 0.2.3"
  gem "debug"
  gem "equivalent-xml", "~> 0.6"
  gem "logger", "1.6.6"
  gem "metanorma"
  gem "metanorma-cli"
  gem "metanorma-generic", ">= 3.3.3"
  gem "metanorma-ieee", ">= 1.6.8"
  gem "metanorma-iso", ">= 3.4.0"
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
