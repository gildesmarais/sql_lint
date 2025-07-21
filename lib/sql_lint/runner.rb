# frozen_string_literal: true

require 'pg_query'

module SqlLint
  # Runs SQL lint checks either sequentially or in parallel based on configuration.
  #
  # Handles execution of all registered checkers and reporting offenses.
  class Runner
    class << self
      def run(sql)
        config = Config.new(Config.load)

        if config.runner_parallel?
          process_checkers_parallel(sql, config)
        else
          process_checkers_sequential(sql, config)
        end
      rescue PgQuery::ParseError
        # ignore fragments
      end

      private

      def process_checkers_sequential(sql, config)
        Registry.each do |checker_class|
          offenses = run_single_checker(checker_class, sql, config)
          report_offenses(offenses, sql) unless offenses.nil?
        end
      end

      def process_checkers_parallel(sql, config)
        threads = Registry.map do |checker_class|
          Thread.new { run_single_checker(checker_class, sql, config) }
        end

        threads.each do |thread|
          offenses = thread.value
          report_offenses(offenses, sql) unless offenses.nil?
        end
      end

      def run_single_checker(checker_class, sql, config)
        checker_name = checker_class.name.split('::').last(2).join('/')
        return nil unless config.enabled?(checker_name)

        checker = checker_class.new(sql)
        checker.offenses
      rescue StandardError => e
        warn "[SQL Lint] ❌ Error in #{checker_name || checker_class.name}: #{e.message}"
        nil
      end

      def report_offenses(offenses, sql)
        offenses.each do |msg|
          warn "[SQL Lint] ⚠️ #{msg}\n  #{sql.strip}"
        end
      end
    end
  end
end
