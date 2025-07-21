# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared_examples_for_checkers'

RSpec.describe SqlLint::Checkers::PostgreSQL::NotInOrInequality do
  test_cases = [
    { sql: 'SELECT * FROM table WHERE col != 5',
      expected_offenses: ['PostgreSQL: NOT IN / != can disable index usage and cause full scans'] },
    { sql: 'SELECT * FROM table WHERE col IN (1, 2, 3)',
      expected_offenses: [] },
    { sql: 'SELECT * FROM table',
      expected_offenses: [] }
  ]

  test_cases.each do |test_case|
    it_behaves_like 'a SQL checker', described_class, test_case[:sql], test_case[:expected_offenses]
  end
end
