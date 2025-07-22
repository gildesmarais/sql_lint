# frozen_string_literal: true

require 'spec_helper'
require 'sql_lint/checkers/postgresql/missing_index_on_foreign_key'

RSpec.describe SqlLint::Checkers::PostgreSQL::MissingIndexOnForeignKey do
  let(:klass) { described_class }

  before do
    ActiveRecord::Schema.define do
      drop_table :comments, if_exists: true
      drop_table :posts, if_exists: true

      create_table :posts, force: true do |t|
        t.string :title
      end

      create_table :comments, force: true do |t|
        t.integer :post_id
        t.string :body
      end

      add_index :posts, :title
      # intentionally no index on comments.post_id
    end
  end

  it 'flags join on *_id column without index' do # rubocop:disable RSpec/ExampleLength
    sql = <<~SQL
      SELECT * FROM posts
      JOIN comments ON comments.post_id = posts.id
    SQL

    offenses = klass.new(sql, connection: ActiveRecord::Base.connection).offenses
    expect(offenses).to include(/comments\.post_id.*no index/)
  end

  it 'does not flag join on *_id column if indexed' do # rubocop:disable RSpec/ExampleLength
    ActiveRecord::Schema.define do
      add_index :comments, :post_id
    end

    sql = <<~SQL
      SELECT * FROM posts
      JOIN comments ON comments.post_id = posts.id
    SQL

    offenses = klass.new(sql, connection: ActiveRecord::Base.connection).offenses
    expect(offenses).to be_empty
  end
end
