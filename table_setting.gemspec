# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'table_setting/version'

Gem::Specification.new do |spec|
  spec.name          = "table_setting"
  spec.version       = TableSetting::VERSION
  spec.authors       = ["Todd Gehman"]
  spec.email         = ["toddgehman@gmail.com"]
  spec.description   = %q{Ruby gem to create a data table that can be easily presented as HTML or Excel with the same human-friendly display styles applied to both. Unstyled formats like CSV are supported as well.}
  spec.summary       = %q{Data table exports with shared custom style settings.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
