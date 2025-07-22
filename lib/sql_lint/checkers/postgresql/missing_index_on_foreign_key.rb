# frozen_string_literal: true

require 'pg_query'

module SqlLint
  module Checkers
    module PostgreSQL
      # Checker to detect missing indexes on foreign key columns in PostgreSQL.
      class MissingIndexOnForeignKey < BaseChecker
        def initialize(sql, connection:)
          super

          @sql = sql
          @connection = connection
        end

        def offenses # rubocop:disable Metrics
          return [] unless /JOIN|WHERE/i.match?(@sql)

          warn_columns = []
          PgQuery.parse(@sql).walk! do |_node, key, value, _location|
            next unless key == :column_ref
            next unless value.fields.all?(&:string)

            parts = value.fields.map { |f| f.string.sval.downcase }
            table, column = parts.size == 2 ? parts : [nil, parts.first]

            next unless column&.end_with?('_id') && table

            warn_columns << [table, column] unless indexed_column?(table, column)
          end

          warn_columns.uniq.map do |table, column|
            "PostgreSQL: column #{table}.#{column} appears to be a foreign key but has no index"
          end
        rescue PgQuery::ParseError
          []
        end

        private

        def indexed_column?(table, column)
          return false unless @connection.data_source_exists?(table)

          @connection.indexes(table).any? { |idx| idx.columns.include?(column) }
        rescue StandardError
          false
        end
      end
    end
  end
end
