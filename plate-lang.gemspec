# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plate/version'

Gem::Specification.new do |spec|
  spec.name          = "plate-lang"
  spec.version       = Plate::VERSION
  spec.authors       = ["tnantoka"]
  spec.email         = ["tnantoka@bornneet.com"]

  spec.summary       = %q{A little language to create one page web sites.}
  spec.description   = %q{A little language to create one page web sites.}
  spec.homepage      = "https://github.com/tnantoka/plate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|website)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7"
  spec.add_development_dependency "racc", "~> 1.4"
  spec.add_development_dependency "activesupport", "~> 4.2"
  spec.add_development_dependency "simplecov", "~> 0.10"
end
