# frozen_string_literal: true

require 'logger'
require 'singleton'
require 'forwardable'

module SqlLint
  # Singleton logger for SqlLint
  class Log
    include Singleton

    class << self
      extend Forwardable
      def_delegators :instance, :debug, :info, :warn, :error, :fatal

      def logger=(new_logger)
        instance.logger = new_logger
      end

      def log_level
        level = ENV['LOG_LEVEL']&.upcase || 'DEBUG'
        begin
          Logger.const_get(level)
        rescue StandardError
          Logger::DEBUG
        end
      end
    end

    attr_writer :logger

    def initialize
      @logger = Logger.new($stdout)
      @logger.level = self.class.log_level
    end

    %i[debug info warn error fatal].each do |method|
      define_method(method) do |message = nil, &block|
        @logger.public_send(method, message, &block)
      end
    end
  end
end
