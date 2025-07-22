# SqlLint

## Level Up Your Rails SQL: Catch Issues Early with SqlLint

SqlLint is a **minimalist, RuboCop-style SQL linter** designed to seamlessly integrate with your Rails test suite. It automatically catches common and DBMS-specific SQL pitfalls, helping you **write more robust, performant, and secure SQL queries** right when you're developing them.

---

## Why SqlLint?

Databases are often the silent bottleneck and source of subtle bugs. SqlLint acts as your vigilant guardrail, providing **real-time feedback** during your test runs. This means you can:

- **Prevent Performance Regressions**: Catch missing `LIMIT` clauses before they hit production.
- **Avoid Data Anomalies**: Be warned about potentially unsafe `UNION` usage.
- **Ensure Cross-DBMS Compatibility**: Leverage adapter-specific rules for PostgreSQL, MySQL, and SQLite.
- **Streamline Code Reviews**: Automate tedious SQL review points, freeing up your team.
- **Boost Developer Confidence**: Write SQL knowing common mistakes are being checked.

---

## Quick Start

Getting started with SqlLint is straightforward.

### Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'sql_lint'
```

Then execute:

```bash
bundle install
```

### Usage

1.  **Integrate with Rails:** Create an initializer file in `config/initializers/sql_lint.rb`:

    ```ruby
    # config/initializers/sql_lint.rb
    if Rails.env.test?
      require "sql_lint"

      # Subscribe to Active Record's SQL notifications
      ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, payload|
        SqlLint::Runner.run(payload[:sql])
      end
    end
    ```

2.  **Run Your Test Suite:** Simply execute your tests as usual (e.g., `bin/rails test`, `rspec`).

    Lint warnings will appear directly in your **STDOUT**, making them easy to spot during development.

---

## Features at a Glance

SqlLint comes packed with intelligent checks to safeguard your SQL:

- **Missing `LIMIT` Detection**: Warns when `SELECT` statements might pull excessively large result sets, preventing performance hits.
- **Unsafe `UNION` Usage**: Flags `UNION` operations that lack the `ALL` keyword, which can lead to unintended deduplication and performance overhead.
- **Multi-DBMS Support**: Ships with robust rule sets for:
  - **PostgreSQL**
  - **MySQL**
  - **SQLite**
  - **Adapter-agnostic** (default) rules that apply across databases.
- **Seamless Rails Integration**: Hooks directly into `ActiveRecord`'s SQL notifications, requiring minimal setup.
- **Extensible Architecture**: Easily add your own custom checkers (perfect for contributions\!).

---

## Configuration

SqlLint offers a flexible, RuboCop-inspired configuration system. Control which checks run using a `.sql_lint.yml` file at your project's root.

### Example `.sql_lint.yml`

```yaml
# Disable all PostgreSQL-specific checks
PostgreSQL:
  Enabled: false

# Disable a specific default check
Default/SelectWithoutLimit:
  Enabled: false

# Optimize performance by enabling parallel execution of checks
Runner:
  Parallel: true
```

### How Configuration Works

- **Default Behavior**: All checkers are **enabled by default** for immediate comprehensive linting.
- **Merging Logic**: Your `.sql_lint.yml` is intelligently merged with the default settings.
- **Granular Control**:
  - Disable **entire categories** (e.g., `PostgreSQL`, `MySQL`, `Default`) by setting `Enabled: false`.
  - Disable **individual checkers** by their full name (e.g., `Default/SelectWithoutLimit`).
  - Enable or disable **parallel runner execution** for faster linting on larger test suites by setting `Runner.Parallel: true`.
- **Implicit Enablement**: If a checker or category isn't specified in your config, it remains enabled by default.

This flexible system provides **fine-grained control** over your SQL linting rules, tailored to your project's specific needs.

---

## Development

Install Ruby 3.3.x locally.

Start PostgreSQL:

```sh
docker-compose up -d
```

Run tests:

```sh
bundle exec rspec
```

Run rubocop:

```sh
bundle exec rubocop
```

Stop when done:

```sh
docker-compose down
```

---

## Contributing to SqlLint

We'd love your help to make SqlLint even better\! Whether you're fixing bugs, adding new checker rules, improving documentation, or optimizing performance, every contribution is highly valued.

- **Ideas for new checkers?** Open an issue to discuss.
- **Want to implement a new rule?** Check out the `checkers/` directory for examples.
- **Found a bug?** Please report it\!

For detailed contribution guidelines, please see the [CONTRIBUTING.md](https://www.google.com/search?q=CONTRIBUTING.md) file.

---

## License

This project is licensed under the European Union Public License (EUPL) version 1.2. See the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

---

## Support

Encounter an issue or have a question? The best way to get support is to [open an issue on GitHub](https://www.google.com/search?q=https://github.com/your-repo-link/issues).

---

### What's next for SqlLint?

We're always looking to expand SqlLint's capabilities. Are there specific SQL patterns or DBMS quirks you'd like to see covered? Let us know in the issues\!
