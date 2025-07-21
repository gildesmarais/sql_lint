require "sql_lint/registry"
require "sql_lint/base_checker"
require "sql_lint/runner"
require "sql_lint/config"

adapter = ActiveRecord::Base.connection.adapter_name.downcase

Dir[File.join(__dir__, "sql_lint/checkers/default/*.rb")].each { |f| require f }

if %w[postgresql mysql sqlite].include?(adapter)
  Dir[File.join(__dir__, "sql_lint/checkers/#{adapter}/*.rb")].each { |f| require f }
end
