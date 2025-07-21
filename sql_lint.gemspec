# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'sql_lint'
  spec.version     = '0.1.0'
  spec.summary     = 'Lints SQL queries during test runs'
  spec.authors     = ['Your Name']
  spec.license = 'EUPL-1.2'
  spec.required_ruby_version = '>= 3.3'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'pg_query'
  spec.add_dependency 'zeitwerk'
end
