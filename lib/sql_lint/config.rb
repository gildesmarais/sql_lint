# frozen_string_literal: true

require 'yaml'

module SqlLint
  # Manages configuration for SqlLint, including loading and merging user config.
  #
  # Provides methods to check if specific checkers or categories are enabled,
  # and whether the runner should execute in parallel.
  class Config
    DEFAULT_CONFIG = {
      'Default' => { 'Enabled' => true },
      'PostgreSQL' => { 'Enabled' => true },
      'MySQL' => { 'Enabled' => true },
      'SQLite' => { 'Enabled' => true }
    }.freeze

    def self.load(path = '.sql_lint.yml')
      if File.exist?(path)
        user_config = YAML.load_file(path) || {}
        deep_merge(DEFAULT_CONFIG, user_config)
      else
        DEFAULT_CONFIG
      end
    end

    def self.deep_merge(hash1, hash2)
      merger = proc { |_key, v1, v2|
        if v1.is_a?(Hash) && v2.is_a?(Hash)
          v1.merge(v2, &merger)
        else
          v2
        end
      }
      hash1.merge(hash2, &merger)
    end

    def initialize(config_hash)
      @config = config_hash
    end

    # Checks if a checker or its category is enabled.
    #
    # @param checker_name [String] Checker name like "Default/SelectWithoutLimit"
    # @return [Boolean]
    def enabled?(checker_name)
      parts = checker_name.split('/')
      category = parts.first
      checker_key = checker_name

      category_enabled = @config.dig(category, 'Enabled')
      return false if category_enabled == false

      checker_enabled = @config.dig(checker_key, 'Enabled')
      checker_enabled != false
    end

    def runner_parallel?
      @config.dig('Runner', 'Parallel') == true
    end
  end
end
