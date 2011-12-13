require 'rubygems'
require 'rubygems/package_task'
require 'rake/clean'
CLEAN.include("pkg/*.gem")


PRUIM_VERSION = "0.1.1"

def apply_spec_defaults(s)
end


 spec = Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Pure Ruby Image Library."
  s.name        = 'pruim'
  s.version     = PRUIM_VERSION
  s.add_dependency('bindata', '>= 1.0.0')
  s.add_development_dependency('atto', '>= 0.9.2')
  s.require_path = 'lib'
  s.files        = ['README', 'Rakefile'] +
                   FileList["lib/pruim.rb", "lib/pruim/*.rb",
                   "test/*.rb"  , "test/pruim/*.rb" ].to_a
  s.description = <<EOF
  Pruim is a Pure Ruby Image Library. Currently only supports BMP, PPM and PBM
  formats, but preserves palette ordering on reading and writing.
EOF
  s.author      = 'beoran'
  s.email       = 'beoran@rubyforge.org'
  s.homepage    = 'http://github.com/beoran/pruim'
  s.date        = Time.now.strftime '%Y-%m-%d'
end

Gem::PackageTask.new(spec) do |pkg|
        pkg.need_zip = false
        pkg.need_tar = false
end


task :test do
  for file in FileList["test/*.rb"  , "test/pruim/*.rb" ] do
    puts("Running tests for #{file}:")
    res = system("ruby -I lib #{file}")
    puts res ? "OK!" : "Failed!"
  end
end

task :default => :test

