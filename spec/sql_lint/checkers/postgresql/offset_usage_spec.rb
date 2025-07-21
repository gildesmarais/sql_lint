# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared_examples_for_checkers'

RSpec.describe SqlLint::Checkers::PostgreSQL::OffsetUsage do
  test_cases = [
    { sql: 'SELECT * FROM table OFFSET 10',
      expected_offenses: [
        'PostgreSQL: OFFSET pagination is inefficient for deep pages ' \
        '— use keyset pagination instead'
      ] },
    { sql: 'SELECT * FROM table LIMIT 10',
      expected_offenses: [] },
    { sql: 'SELECT * FROM table',
      expected_offenses: [] }
  ]

  test_cases.each do |test_case|
    it_behaves_like 'a SQL checker', described_class, test_case[:sql], test_case[:expected_offenses]
  end
end
