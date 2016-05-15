# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zenhub2pivotal/version'

Gem::Specification.new do |spec|
  spec.name          = "zenhub2pivotal"
  spec.version       = Zenhub2pivotal::VERSION
  spec.authors       = ["Hiroki Yoshioka"]
  spec.email         = ["irohiroki@gmail.com"]

  spec.summary       = %q{Exports issues from Zenhub and imports to Pivotal Tracker.}
  spec.description   = %q{Exports issues from Zenhub and imports to Pivotal Tracker.}
  spec.homepage      = "https://github.com/irohiroki/zenhub2pivotal"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "octokit"
  spec.add_dependency "zenhub_ruby"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
