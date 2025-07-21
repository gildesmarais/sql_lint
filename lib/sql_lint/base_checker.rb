# frozen_string_literal: true

module SqlLint
  # Base class for all SQL lint checkers.
  #
  # This class provides the interface and common behavior for all checkers.
  # Subclasses should implement the `offenses` method to return an array of
  # offense messages for the given SQL.
  class BaseChecker
    def self.inherited(subclass)
      super
      Registry.register(subclass)
    end

    def initialize(sql)
      @sql = sql
    end

    # Returns an array of offense messages found in the SQL.
    #
    # @return [Array<String>]
    def offenses
      raise NotImplementedError
    end
  end
end
