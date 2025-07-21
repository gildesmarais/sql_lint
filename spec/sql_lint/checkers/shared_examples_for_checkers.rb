RSpec.shared_examples 'a SQL checker' do |checker_class, sql, expected_offenses|
  subject(:checker) { checker_class.new(sql) }

  describe '#offenses' do
    it 'returns the expected offenses' do
      expect(checker.offenses).to eq(expected_offenses)
    end
  end
end
