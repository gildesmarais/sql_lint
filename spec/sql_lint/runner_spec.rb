# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SqlLint::Runner do
  let(:sql) { 'SELECT * FROM users' }
  let(:checker_class) do
    Class.new do
      def self.name
        'SqlLint::Checkers::TestChecker'
      end

      def initialize(sql)
        @sql = sql
      end

      def offenses
        ['offense message']
      end
    end
  end

  before do
    @original_checkers = SqlLint::Registry.class_variable_get(:@@checkers)
    SqlLint::Registry.class_variable_set(:@@checkers, [checker_class])
    allow_any_instance_of(SqlLint::Config).to receive(:enabled?).and_return(true)
  end

  after do
    SqlLint::Registry.class_variable_set(:@@checkers, @original_checkers)
  end

  describe '.run' do
    context 'when checkers are enabled' do
      it 'runs enabled checkers and outputs warnings for offenses' do
        expect do
          described_class.run(sql)
        end.to output(/\[SQL Lint\] ⚠️ offense message/).to_stderr
      end
    end

    context 'when checkers are disabled' do
      it 'does not output warnings for offenses' do
        allow_any_instance_of(SqlLint::Config).to receive(:enabled?).and_return(false)
        expect do
          described_class.run(sql)
        end.not_to output.to_stderr
      end
    end

    context 'when PgQuery::ParseError is raised' do
      it 'rescues the error without raising' do
        SqlLint::Registry.class_variable_set(:@@checkers, [])
        pg_query_error_class = Class.new(StandardError)
        stub_const('PgQuery', Module.new)
        stub_const('PgQuery::ParseError', pg_query_error_class)
        allow(SqlLint::Registry).to receive(:all).and_raise(PgQuery::ParseError)
        expect do
          described_class.run(sql)
        end.not_to raise_error
      end
    end
  end
end
