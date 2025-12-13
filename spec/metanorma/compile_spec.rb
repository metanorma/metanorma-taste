# frozen_string_literal: true

require "fileutils"

RSpec.describe "Metanorma Taste Compilation" do
  # Discover available tastes
  available_tastes = begin
    require_relative "../spec_helper"
    Metanorma::TasteRegister.instance.available_tastes
  end

  let(:input_file) { "spec/assets/test.adoc" }
  let(:base_dir) { "spec/assets" }
  let(:base_name) { "test" }

  # Helper to clean up generated files
  def cleanup_files(base_name, base_dir)
    Dir.glob(File.join(base_dir, "#{base_name}.*")).each do |file|
      FileUtils.rm_f(file) unless file.end_with?(".adoc")
    end
  end

  # Helper to compile a taste
  def compile_taste(taste, input_file)
    require "metanorma"
    compile = Metanorma::Compile.new
    compile.compile(input_file, type: taste.to_s, agree_to_terms: true)
    compile
  end

  # Helper to validate output files
  def validate_output(compile, base_name, base_dir)
    format_mapping = compile.output_format_mapping
    generated_files = Dir.glob(File.join(base_dir, "#{base_name}.*"))
      .reject { |f| f.end_with?(".adoc") }
      .map { |f| File.basename(f) }

    missing_files = []
    empty_files = []

    format_mapping.each do |_format, extension|
      expected_file = "#{base_name}.#{extension}"
      filepath = File.join(base_dir, expected_file)

      if File.exist?(filepath)
        if File.size(filepath).zero?
          empty_files << expected_file
          missing_files << "#{expected_file} (empty)"
        end
      else
        missing_files << expected_file
      end
    end

    {
      generated: generated_files,
      missing: missing_files,
      empty: empty_files,
      valid: missing_files.empty?
    }
  end

  # Dynamically create a test for each available taste
  available_tastes.each do |taste|
    it "compiles blank document for #{taste} taste" do
      # Clean up before compilation
      cleanup_files(base_name, base_dir)

      # Compile
      compile = compile_taste(taste, input_file)

      # Validate
      result = validate_output(compile, base_name, base_dir)

      unless result[:valid]
        fail "#{taste} compilation failed:\n" \
             "  Missing files: #{result[:missing].join(', ')}\n" \
             "  Generated files: #{result[:generated].join(', ')}"
      end

      expect(result[:valid]).to be true
      expect(result[:generated].size).to be > 0
    end
  end
end