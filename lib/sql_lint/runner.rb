module SqlLint
  class Runner
    def self.run(sql)
      Registry.all.each do |checker_class|
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
