require "fileutils"

RSpec.describe "Metanorma Taste Compilation" do
  it "compiles blank documents for each taste" do
    # Get available tastes by loading metanorma-taste in isolation
    require_relative "../spec_helper"
    register = Metanorma::TasteRegister.instance
    available_tastes = register.available_tastes.map(&:to_s)
    
    # Test each taste in a separate subprocess to avoid circular dependencies
    available_tastes.each do |taste|
      # Run compilation in a subprocess to avoid circular dependency
      compilation_script = <<~RUBY
        require 'metanorma'
        require 'fileutils'
        
        # Clean up all test.* files except test.adoc to start with a blank slate
        puts "Cleaning up files before #{taste} compilation..."
        files_before = Dir.glob("spec/assets/test.*")
        puts "Files before cleanup: \#{files_before.join(', ')}"
        
        Dir.glob("spec/assets/test.*").each do |file|
          unless file.end_with?("test.adoc")
            FileUtils.rm_f(file)
          end
        end
        
        files_after_cleanup = Dir.glob("spec/assets/test.*")
        puts "Files after cleanup: \#{files_after_cleanup.join(', ')}"
        
        # Redirect stderr to a file so we can check for errors
        stderr_file = 'compilation_stderr_#{taste}.log'
        
        begin
          # Redirect stderr to capture compilation errors
          original_stderr = $stderr
          File.open(stderr_file, 'w') do |f|
            $stderr = f
            
            compile = Metanorma::Compile.new
            compile.compile('spec/assets/test.adoc',
                            type: '#{taste}',
                            agree_to_terms: true)
            
            # Use output_format_mapping to determine expected files
            format_mapping = compile.output_format_mapping
            puts "Expected formats for #{taste}: \#{format_mapping.inspect}"
            
            # Check that all expected output files were generated
            missing_files = []
            generated_files = Dir.glob('spec/assets/test.*')
            puts "Files after compilation: \#{generated_files.join(', ')}"
            
            format_mapping.each do |format, suffix|
              expected_file = "spec/assets/test.\#{suffix}"
              unless File.exist?(expected_file)
                missing_files << expected_file
                puts "Missing expected file: \#{expected_file}"
              else
                file_size = File.size(expected_file)
                # puts "Found expected file: \#{expected_file} (size: \#{file_size} bytes)"
                # Check if file is empty or suspiciously small
                if file_size == 0
                  missing_files << "\#{expected_file} (empty file)"
                  puts "WARNING: \#{expected_file} exists but is empty!"
                end
              end
            end
            
            if missing_files.empty?
              puts "SUCCESS: #{taste} - All expected files generated: \#{format_mapping.values.map { |s| 'test.' + s }.join(', ')}"
            else
              puts "FAILED: #{taste} - Missing files: \#{missing_files.join(', ')}"
              puts "Generated files: \#{generated_files.join(', ')}"
              exit 1
            end
          end
          
          # Restore stderr
          $stderr = original_stderr
          
          # Read the stderr content
          stderr_content = File.exist?(stderr_file) ? File.read(stderr_file) : ""
          
          # Check for critical errors in stderr that indicate failures
          critical_errors = [
            'Fatal error!',
            'mn2pdf failed!',
            'ValidationException',
            'TransformerException: org.apache.fop.fo.ValidationException',
            'NullPointerException'
          ]
          
          has_critical_error = critical_errors.any? { |error| stderr_content.include?(error) }
          
          if has_critical_error
            puts "FAILED: #{taste} - Critical errors detected in compilation output"
            puts "Error indicators found: \#{critical_errors.select { |e| stderr_content.include?(e) }.join(', ')}"
            exit 1
          end
          
        rescue SystemExit => e
          # Restore stderr before handling exit
          $stderr = original_stderr if defined?(original_stderr)
          # Only treat non-zero exit codes as failures
          if e.status != 0
            puts "FAILED: #{taste} - SystemExit with code: \#{e.status}"
            exit 1
          else
            # Exit code 0 means success, re-raise to exit cleanly
            raise
          end
        rescue => e
          # Restore stderr before handling error
          $stderr = original_stderr if defined?(original_stderr)
          puts "FAILED: #{taste} - Error: \#{e.message}"
          exit 1
        ensure
          # Clean up stderr file
          File.delete(stderr_file) if File.exist?(stderr_file)
        end
      RUBY
      
      # Write the script to a temporary file
      script_file = "tmp_compile_#{taste}.rb"
      File.write(script_file, compilation_script)
      
      begin
        # Execute the script in a subprocess
        result = system("ruby #{script_file}")
        
        if result
          puts "✓ #{taste} compilation succeeded"
        else
          fail "Compilation failed for taste: #{taste}"
        end
      ensure
        # Clean up the temporary script file
        File.delete(script_file) if File.exist?(script_file)
      end
    end
  end
end
