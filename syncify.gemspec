# -*- encoding: utf-8 -*-
require File.expand_path('../lib/syncify/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["mln"]
  gem.email         = ["mlnkrish86@gmail.com"]
  gem.description   = %q{Keep two folders in sync}
  gem.summary       = %q{Keep two folders in sync. Works across S3 and local Filesystem.}
  gem.homepage      = "https://github.com/mlnkrish/syncify"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "syncify"
  gem.require_paths = ["lib"]
  gem.version       = Syncify::VERSION

  gem.add_dependency("fog",">=1.3.1")
  gem.add_development_dependency("rspec", ">= 2.6.0")
end