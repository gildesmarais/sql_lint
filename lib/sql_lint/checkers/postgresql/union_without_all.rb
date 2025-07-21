# frozen_string_literal: true

module SqlLint
  module Checkers
    module PostgreSQL
      # Checker that detects PostgreSQL UNION statements without the ALL keyword.
      #
      # This check warns about potential performance issues due to deduplication sorting.
      class UnionWithoutAll < BaseChecker
        PATTERN = /\bUNION\b(?!\s+ALL)/i
        def offenses
          PATTERN.match?(@sql) ? ['PostgreSQL: UNION without ALL (deduplication sort)'] : []
        end
      end
    end
  end
end
