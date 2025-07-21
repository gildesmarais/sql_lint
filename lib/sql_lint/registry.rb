module SqlLint
  class Registry
    @checkers = []

    def self.register(klass)
      @checkers << klass
    end

    def self.all
      @checkers
    end
  end
end
