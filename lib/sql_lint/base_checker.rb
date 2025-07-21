module SqlLint
  class BaseChecker
    def self.inherited(subclass)
      Registry.register(subclass)
    end

    def initialize(sql)
      @sql = sql
    end

    def offenses
      raise NotImplementedError
    end
  end
end
