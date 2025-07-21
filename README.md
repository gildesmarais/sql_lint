# SqlLint

Minimal RuboCop-style SQL linter for Rails test runs with DBMS-specific rules.

## Usage

1. Add to Gemfile:
   gem "sql_lint", path: "./sql_lint"

2. Create initializer:

   # config/initializers/sql_lint.rb
   if Rails.env.test?
     require "sql_lint"

     ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, payload|
       SqlLint::Runner.run(payload[:sql])
     end
   end

3. Run your test suite. Lint warnings appear in STDOUT.

## Rule Sets

- checkers/default/ → adapter-agnostic rules
- checkers/postgresql/, mysql/, sqlite/ → adapter-specific rules

## Configuration

SqlLint supports a RuboCop-style configuration file named `.sql_lint.yml` placed at the root of your project. This file allows you to enable or disable specific checkers or entire categories of checkers.

### Example `.sql_lint.yml`

```yaml
# Disable all PostgreSQL-specific checks
PostgreSQL:
  Enabled: false

# Disable a specific default check
Default/SelectWithoutLimit:
  Enabled: false
```

### How it works

- The configuration file is merged with the default settings, which enable all checkers by default.
- You can disable entire categories (e.g., `PostgreSQL`, `MySQL`, `Default`) by setting `Enabled: false`.
- You can disable individual checkers by specifying their full name, e.g., `Default/SelectWithoutLimit`.
- If a checker or category is not specified, it defaults to enabled.

This configuration system gives you fine-grained control over which SQL linting rules are applied during your test runs.
