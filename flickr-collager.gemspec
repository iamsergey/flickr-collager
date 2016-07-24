# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flickr/collager/version'

Gem::Specification.new do |spec|
  spec.name          = "flickr-collager"
  spec.version       = Flickr::Collager::VERSION
  spec.authors       = ["iamsergey"]
  spec.email         = ["noen@list.ru"]

  spec.summary       = %q{A simple Flickr collage maker}
  spec.homepage      = "https://github.com/aimsergey/flickr-collager"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "curb"
  spec.add_dependency "rmagick"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
