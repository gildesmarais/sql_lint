require "pg_query"

module SqlLint
  class Runner
    def self.run(sql)
      @config ||= Config.new(Config.load)

      if @config.runner_parallel?
        run_parallel(sql)
      else
        run_sequential(sql)
      end
    rescue PgQuery::ParseError
      # ignore fragments
    end

    def self.run_sequential(sql)
      Registry.all.each do |checker_class|
        checker_name = checker_class.name.split("::").last(2).join("/")
        next unless @config.enabled?(checker_name)

        checker = checker_class.new(sql)
        checker.offenses.each do |msg|
          warn "[SQL Lint] ⚠️ #{msg}\n  #{sql.strip}"
        end
      end
    end

    def self.run_parallel(sql)
      tasks = Registry.all.map do |checker_class|
        Thread.new do
          checker_name = checker_class.name.split("::").last(2).join("/")
          next unless @config.enabled?(checker_name)

          checker = checker_class.new(sql)
          offenses = checker.offenses
          [checker_name, offenses]
        end
      end

      tasks.each do |task|
        checker_name, offenses = task.value
        next if offenses.nil?

        offenses.each do |msg|
          warn "[SQL Lint] ⚠️ #{msg}\n  #{sql.strip}"
        end
      end
    end
  end
end
