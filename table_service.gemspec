# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'table_service/version'

Gem::Specification.new do |spec|
  spec.name          = "table_service"
  spec.version       = TableService::VERSION
  spec.authors       = ["Todd Gehman"]
  spec.email         = ["toddgehman@gmail.com"]
  spec.description   = %q{Facilitates a data table structure that can be trivially exported as HTML, XLS, CSV, etc while allowing human-friendly custom styles to be shared between the HTML and Excel formats.}
  spec.summary       = %q{Data table exports with shared custom formatting.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
