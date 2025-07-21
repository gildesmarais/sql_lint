# frozen_string_literal: true

module SqlLint
  module Checkers
    module PostgreSQL
      # Checker for ILIKE usage which may bypass indexes (use trigram or expression index)
      class IlikeUsage < BaseChecker
        PATTERN = /\bILIKE\b/i

        def offenses
          PATTERN.match?(@sql) ? ['PostgreSQL: ILIKE may bypass indexes (use trigram or expression index)'] : []
        end
      end
    end
  end
end
