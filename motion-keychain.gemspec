# -*- encoding: utf-8 -*-
VERSION = "1.0"

Gem::Specification.new do |spec|
  spec.name          = "motion-keychain"
  spec.version       = VERSION
  spec.authors       = ["Gant"]
  spec.email         = ["GantMan@gmail.com"]
  spec.description   = "Simple wrapper for Keychain on iOS and OS X."
  spec.summary       = "The motion-keychain gem is a simple wrapper for Keychain on iOS and OS X. Makes using Keychain APIs as easy as NSUserDefaults."
  spec.homepage      = ""
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_dependency "motion-cocoapods", ">= 1.5.0"
end
