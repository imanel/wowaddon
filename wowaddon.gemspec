# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wowaddon/version'

Gem::Specification.new do |spec|
  spec.name          = "wowaddon"
  spec.version       = Wowaddon::VERSION
  spec.authors       = ["Bernard Potocki"]
  spec.email         = ["bernard.potocki@imanel.org"]

  spec.summary       = %q{Simple gem to manage World of Warcraft packages.}
  spec.description   = %q{Simple gem to manage World of Warcraft packages.}
  spec.homepage      = "https://github.com/imanel/wowaddon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = `git ls-files -- bin/*`.lines.map { |f| File.basename(f.chomp) }
  spec.require_paths = ["lib"]

  spec.add_dependency('activerecord', '~> 5.0')
  spec.add_dependency('sqlite3', '~> 1.3.11')
end
