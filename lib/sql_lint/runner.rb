require "sql_lint/config"

module SqlLint
  class Runner
    def self.run(sql)
      @config ||= Config.new(Config.load)

      Registry.all.each do |checker_class|
        checker_name = checker_class.name.split("::").last(2).join("/")
        next unless @config.enabled?(checker_name)

        checker = checker_class.new(sql)
        checker.offenses.each do |msg|
          warn "[SQL Lint] ⚠️ #{msg}\n  #{sql.strip}"
        end
      end
    rescue PgQuery::ParseError
      # ignore fragments
    end
  end
end
