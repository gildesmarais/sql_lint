module SqlLint
  module Checkers
    module PostgreSQL
      class UnionWithoutAll < BaseChecker
        PATTERN = /\bUNION\b(?!\s+ALL)/i
        def offenses
          PATTERN.match?(@sql) ? ["PostgreSQL: UNION without ALL (deduplication sort)"] : []
        end
      end
    end
  end
end
