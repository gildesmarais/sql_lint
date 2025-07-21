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
