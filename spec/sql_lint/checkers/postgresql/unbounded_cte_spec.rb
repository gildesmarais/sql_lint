# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared_examples_for_checkers'

RSpec.describe SqlLint::Checkers::PostgreSQL::UnboundedCte do
  test_cases = [
    { sql: 'WITH cte AS (SELECT * FROM table)',
      expected_offenses: [
        'PostgreSQL: CTE without LIMIT — may materialize large temp result (CTEs are optimization fences pre-PG12)'
      ] },
    { sql: 'WITH cte AS (SELECT * FROM table LIMIT 10)',
      expected_offenses: [] },
    { sql: 'SELECT * FROM table',
      expected_offenses: [] },
    { sql: 'WITH cte AS (SELECT 1); SELECT * FROM other;',
      expected_offenses: [
        'PostgreSQL: CTE without LIMIT — may materialize large temp result (CTEs are optimization fences pre-PG12)'
      ] }
  ]

  test_cases.each do |test_case|
    it_behaves_like 'a SQL checker', described_class, test_case[:sql], test_case[:expected_offenses]
  end
end
