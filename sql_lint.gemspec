Gem::Specification.new do |spec|
  spec.name        = "sql_lint"
  spec.version     = "0.1.0"
  spec.summary     = "Lints SQL queries during test runs"
  spec.authors     = ["Your Name"]
  spec.files       = Dir["lib/**/*"]
  spec.require_paths = ["lib"]
  spec.add_dependency "pg_query"

  spec.add_development_dependency "rspec", "~> 3.12"
end
