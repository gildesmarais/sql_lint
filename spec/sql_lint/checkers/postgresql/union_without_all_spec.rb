# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared_examples_for_checkers'

RSpec.describe SqlLint::Checkers::PostgreSQL::UnionWithoutAll do
  test_cases = [
    { sql: 'SELECT * FROM table1 UNION SELECT * FROM table2',
      expected_offenses: ['PostgreSQL: UNION without ALL (deduplication sort)'] },
    { sql: 'SELECT * FROM table1 UNION ALL SELECT * FROM table2', expected_offenses: [] },
    { sql: 'SELECT * FROM table1', expected_offenses: [] }
  ]

  test_cases.each do |test_case|
    it_behaves_like 'a SQL checker', described_class, test_case[:sql], test_case[:expected_offenses]
  end
end
