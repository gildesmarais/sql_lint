# frozen_string_literal: true

module SqlLint
  module Checkers
    module PostgreSQL
      # Checker for NOT IN / != which can disable index usage and cause full scans
      class NotInOrInequality < BaseChecker
        PATTERN = /(!=|NOT\s+IN)/i

        def offenses
          PATTERN.match?(@sql) ? ['PostgreSQL: NOT IN / != can disable index usage and cause full scans'] : []
        end
      end
    end
  end
end
