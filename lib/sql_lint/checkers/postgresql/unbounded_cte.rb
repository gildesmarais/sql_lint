# frozen_string_literal: true

module SqlLint
  module Checkers
    module PostgreSQL
      # Checker for CTEs without a LIMIT clause (may materialize large temp result).
      class UnboundedCte < BaseChecker
        CTE_PATTERN = /\bWITH\b\s+\w+\s+AS\s*\(\s*SELECT\b(?![^;]*\bLIMIT\b)/im

        def offenses
          if CTE_PATTERN.match?(@sql)
            [
              'PostgreSQL: CTE without LIMIT — may materialize large temp result ' \
              '(CTEs are optimization fences pre-PG12)'
            ]
          else
            []
          end
        end
      end
    end
  end
end
