require "spec_helper"
require_relative "../shared_examples_for_checkers"


RSpec.describe SqlLint::Checkers::Default::SelectWithoutLimit do
  test_cases = [
    { sql: "SELECT * FROM users", expected_offenses: ["SELECT without LIMIT"] },
    { sql: "SELECT * FROM users LIMIT 10", expected_offenses: [] }
  ]

  test_cases.each do |test_case|
    it_behaves_like "a SQL checker", described_class, test_case[:sql], test_case[:expected_offenses]
  end
end
