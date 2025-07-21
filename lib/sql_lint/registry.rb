# frozen_string_literal: true

module SqlLint
  class Registry
    include Enumerable

    @@checkers = []

    def self.register(klass)
      @@checkers << klass
    end

    def self.all
      @@checkers
    end

    def self.each(&)
      @@checkers.each(&)
    end
  end
end
