# frozen_string_literal: true

require 'sql_lint'
require 'active_record'
require_relative 'support/log_capture_helper'

RSpec.configure do |config|
  config.include LogCaptureHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.warnings = true

  # Use the documentation formatter for detailed output,
  # unless a formatter has already been configured
  config.default_formatter = 'doc' if config.formatters.none?

  config.order = :random

  Kernel.srand config.seed

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      host: 'localhost',
      port: 5433,
      # keep in sync with the docker-compose file
      username: 'test',
      password: 'test',
      database: 'sql_lint_test'
    )
  end
end
