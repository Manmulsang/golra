# frozen_string_literal: true

require_relative "lib/golra/version"

Gem::Specification.new do |spec|
  spec.name = "golra"
  spec.version = Golra::VERSION
  spec.authors = ["pekopekopekopayo"]
  spec.email = ["dlehddus1285@gmail.com"]

  spec.summary = "A flexible filtering library for Rails models"
  spec.description = "Golra provides a simple and extensible way to filter ActiveRecord models."
  spec.homepage = "https://github.com/Manmulsang/golra"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency("activerecord", ">= 6.0")
  spec.add_dependency("activesupport", ">= 6.0")
end
