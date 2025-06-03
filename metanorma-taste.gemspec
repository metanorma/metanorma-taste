# frozen_string_literal: true

require_relative "lib/metanorma/taste/version"

all_files_in_git = Dir.chdir(File.expand_path(__dir__)) do
  `git ls-files -z`.split("\x0")
end

Gem::Specification.new do |spec|
  spec.name = "metanorma-taste"
  spec.version = Metanorma::Taste::VERSION
  spec.authors = ["Ribose Inc."]
  spec.email = ["open.source@ribose.com"]

  spec.summary = "Metanorma Taste Library"
  spec.description = "Library to process and handle default Metanorma Tastes, providing configuration-driven customization of Metanorma flavours."
  spec.homepage = "https://github.com/metanorma/metanorma-taste"
  spec.license = "BSD-2-Clause"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.1.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  # Specify which files should be added to the gem when it is released.
  spec.files = all_files_in_git
    .reject { |f| f.match(%r{\A(?:test|spec|features|bin|\.github)/}) }
    .reject { |f| f.match(%r{Rakefile|bin/rspec}) }
    .reject { |f| f.match(%r{flake|\.(?:direnv|pryrc|irbrc|nix)}) }

  spec.extra_rdoc_files = %w[README.adoc LICENSE.txt]
  spec.bindir = "bin"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "debug"
  spec.add_development_dependency "equivalent-xml", "~> 0.6"
  spec.add_development_dependency "metanorma"
  spec.add_development_dependency "metanorma-iso"
  spec.add_development_dependency "mnconvert"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-command", "~> 1.0"
  spec.add_development_dependency "rubocop", "~> 1"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "sassc-embedded", "~> 1"
  spec.add_development_dependency "simplecov", "~> 0.15"
  spec.add_development_dependency "xml-c14n"
end
