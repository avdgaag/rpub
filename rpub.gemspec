# -*- encoding: utf-8 -*-
require './lib/rpub/version'

Gem::Specification.new do |s|
  # Metadata
  s.name        = 'rpub'
  s.version     = Rpub::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Arjan van der Gaag']
  s.email       = %q{arjan@arjanvandergaag.nl}
  s.description = %q{an ePub generation library in Ruby}
  s.homepage    = %q{http://avdgaag.github.com/rpub}
  s.summary     = <<-EOS
rPub is a command-line tool that generates a collection of plain text input
files into an eBook in ePub format. It provides several related functions to
make working with ePub files a little easier:

* Generation of table of contents
* Packaging your eBook in an archive with additional README file
* Embedding fonts
* Easy previewing as you write
EOS

  # Files
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Rdoc
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = [
     'LICENSE',
     'README.md',
     'HISTORY.md'
  ]

  # Dependencies
  s.add_runtime_dependency 'typogruby'
  s.add_runtime_dependency 'kramdown'
  s.add_runtime_dependency 'rubyzip'
  s.add_runtime_dependency 'builder'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'textstats'
  s.add_runtime_dependency 'typogruby'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'growl'
  s.add_development_dependency 'simplecov'
end

