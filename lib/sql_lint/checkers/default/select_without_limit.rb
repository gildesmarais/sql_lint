module SqlLint
  module Checkers
    module Default
      class SelectWithoutLimit < BaseChecker
        PATTERN = /\ASELECT\b(?!.*LIMIT)/im
        def offenses
          PATTERN.match?(@sql) ? ["SELECT without LIMIT"] : []
        end
      end
    end
  end
end
