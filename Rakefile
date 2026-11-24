require "bundler/gem_tasks"
require "rspec/core/rake_task"

# The gem ships precompiled CSS: released metanorma gems never compile
# SCSS at runtime (the released metanorma-iso 3.5.12-3.5.22 shipped
# SCSS-only and were yanked - metanorma/isodoc#862, #1763). Every
# data/<flavor>/*.scss must have a sibling .css, committed and fresh at
# release time (pre_build_command in release.yml), and the flavor
# configs wire the .css so consumers never require sassc-embedded. The
# compiled CSS keeps the isodoc liquid font placeholders; fonts resolve
# per document at render time through liquid, not sassc.
SCSS_GLOB = "data/*/*.scss"

RSpec::Core::RakeTask.new(:spec)

desc "Compile every data SCSS to its sibling CSS"
task :build_scss do
  require "isodoc/gem_tasks"
  Dir[SCSS_GLOB].sort.each do |src|
    css = src.sub(/\.scss\z/, ".css")
    File.write(css, IsoDoc::GemTasks.compile_scss(src), encoding: "UTF-8")
    puts "#{src} -> #{css}"
  end
end

desc "Fail the build when a data SCSS has no sibling precompiled CSS"
task :scss_css_guard do
  missing = Dir[SCSS_GLOB].reject do |src|
    File.exist?(src.sub(/\.scss\z/, ".css"))
  end
  unless missing.empty?
    raise "SCSS without precompiled sibling CSS - run rake build_scss and commit the CSS files: #{missing.join(', ')}"
  end
end

task default: %i[spec scss_css_guard]
