# frozen_string_literal: true

require 'spec_helper'
require_relative '../shared_examples_for_checkers'

RSpec.describe SqlLint::Checkers::PostgreSQL::IlikeUsage do
  test_cases = [
    { sql: "SELECT * FROM table WHERE col ILIKE 'foo'",
      expected_offenses: ['PostgreSQL: ILIKE may bypass indexes (use trigram or expression index)'] },
    { sql: "SELECT * FROM table WHERE col LIKE 'foo'",
      expected_offenses: [] },
    { sql: 'SELECT * FROM table',
      expected_offenses: [] }
  ]

  test_cases.each do |test_case|
    it_behaves_like 'a SQL checker', described_class, test_case[:sql], test_case[:expected_offenses]
  end
end
