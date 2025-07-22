# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SqlLint::Runner do
  let(:sql) { 'SELECT * FROM users' }
  let(:checker_class) do
    Class.new do
      def self.name
        'SqlLint::Checkers::TestChecker'
      end

      def initialize(sql, connection: nil, **_options)
        @sql = sql
        @connection = connection
      end

      def offenses
        ['offense message']
      end
    end
  end

  let(:original_checkers) { SqlLint::Registry.instance_variable_get(:@checkers) }

  before do
    SqlLint::Registry.instance_variable_set(:@checkers, [checker_class])
  end

  after do
    SqlLint::Registry.instance_variable_set(:@checkers, original_checkers)
  end

  describe '.run' do
    context 'when checkers are enabled' do
      before do
        allow(SqlLint::Config).to receive(:new).and_return(instance_double(SqlLint::Config, runner_parallel?: false,
                                                                                            enabled?: true))
      end

      it 'logs offense messages' do
        output = capture_log do
          described_class.run(sql)
        end

        expect(output).to match(/\[SQL Lint\] ⚠️ offense message/)
      end
    end

    context 'when checkers are disabled' do
      it 'does not output warnings for offenses' do
        allow(SqlLint::Config).to receive(:new).and_return(instance_double(SqlLint::Config, enabled?: false,
                                                                                            runner_parallel?: false))
        expect do
          described_class.run(sql)
        end.not_to output.to_stderr
      end
    end

    context 'when PgQuery::ParseError is raised' do
      it 'rescues the error without raising' do # rubocop:disable RSpec/ExampleLength
        SqlLint::Registry.instance_variable_set(:@checkers, [])
        pg_query_error_class = Class.new(StandardError)
        stub_const('PgQuery', Module.new)
        stub_const('PgQuery::ParseError', pg_query_error_class)
        allow(SqlLint::Registry).to receive(:all).and_raise(PgQuery::ParseError)
        allow(SqlLint::Config).to receive(:new).and_return(instance_double(SqlLint::Config, enabled?: true,
                                                                                            runner_parallel?: false))
        expect do
          described_class.run(sql)
        end.not_to raise_error
      end
    end
  end
end
