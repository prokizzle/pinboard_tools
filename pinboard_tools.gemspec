# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pinboard_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "pinboard_tools"
  spec.version       = PinboardTools::VERSION
  spec.authors       = ["Nick Prokesch"]
  spec.email         = ["nick@prokes.ch"]
  spec.summary       = %q{a helpful organizer for your existing Pinboard bookmarks}
  spec.description   = %q{Auto-tagger with embedly support, safari reading list importer, dead link remover}
  spec.homepage      = "http://nick.prokes.ch"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths    = ["lib"]
  spec.bindir = 'bin'
  spec.executables << 'pinboardtools'

  spec.add_dependency "pinboard", "~> 0.1"
  spec.add_dependency "nokogiri-plist", "~> 0.5"
  spec.add_dependency "progress_bar", "~> 1.0"
  spec.add_dependency "embedly", "~> 1.8"
end