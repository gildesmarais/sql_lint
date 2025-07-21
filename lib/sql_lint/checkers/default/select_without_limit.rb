# frozen_string_literal: true

module SqlLint
  module Checkers
    module Default
      # Checker that detects SELECT statements without a LIMIT clause.
      #
      # This check helps prevent unbounded queries that may return excessive rows.
      class SelectWithoutLimit < BaseChecker
        PATTERN = /\ASELECT\b(?!.*LIMIT)/im
        def offenses
          PATTERN.match?(@sql) ? ['SELECT without LIMIT'] : []
        end
      end
    end
  end
end
