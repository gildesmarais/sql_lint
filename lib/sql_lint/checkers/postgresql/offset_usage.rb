# frozen_string_literal: true

module SqlLint
  module Checkers
    module PostgreSQL
      # Checker for OFFSET pagination inefficiency (inefficient for deep pages — use keyset pagination instead)
      class OffsetUsage < BaseChecker
        PATTERN = /\bOFFSET\s+\d+/i

        def offenses
          if PATTERN.match?(@sql)
            [
              'PostgreSQL: OFFSET pagination is inefficient for deep pages ' \
              '— use keyset pagination instead'
            ]
          else
            []
          end
        end
      end
    end
  end
end
