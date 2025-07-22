# frozen_string_literal: true

require 'pg_query'

module SqlLint
  module Checkers
    module PostgreSQL
      module QueryParserHelpers # rubocop:disable Style/Documentation
        private

        def indexed_column?(table, column)
          return false unless @connection.data_source_exists?(table)

          @connection.indexes(table).any? { |idx| idx.columns.include?(column) }
        rescue StandardError
          false
        end

        def parse_sql(sql)
          PgQuery.parse(sql)
        rescue PgQuery::ParseError
          nil
        end

        def extract_column_references(parsed_tree)
          return [] unless parsed_tree

          columns = []
          parsed_tree.walk! do |_node, key, value, _location|
            next unless key == :column_ref
            next unless value.fields.all?(&:string)

            parts = value.fields.map { |f| f.string.sval.downcase }
            table, column = parts.size == 2 ? parts : [nil, parts.first]
            columns << [table, column]
          end
          columns
        end

        def foreign_key_columns(parsed_tree)
          extract_column_references(parsed_tree).select do |table, column|
            table && column&.end_with?('_id')
          end
        end
      end
    end
  end
end
