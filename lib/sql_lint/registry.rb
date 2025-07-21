# frozen_string_literal: true

module SqlLint
  # Registry for all registered SQL lint checker classes.
  #
  # Manages the collection of checkers and provides enumeration.
  class Registry
    include Enumerable

    @checkers = []
    @mutex = Mutex.new

    def self.register(klass)
      @mutex.synchronize do
        @checkers << klass
      end
    end

    def self.all
      @mutex.synchronize do
        @checkers.dup.freeze
      end
    end

    def self.each(&block)
      @mutex.synchronize do
        @checkers.each(&block)
      end
    end
  end
end
