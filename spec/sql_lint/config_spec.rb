require 'spec_helper'
require 'sql_lint/config'
require 'tempfile'
require 'yaml'

RSpec.describe SqlLint::Config do
  let(:default_config) { described_class::DEFAULT_CONFIG }

  describe '.load' do
    context 'when no config file exists' do
      it 'returns the default config' do
        config = described_class.load('nonexistent.yml')
        expect(config).to eq(default_config)
      end
    end

    context 'when a config file exists' do
      it 'merges user config with default config' do
        Tempfile.create('.sql_lint.yml') do |file|
          user_config = {
            'PostgreSQL' => { 'Enabled' => false },
            'Default/SelectWithoutLimit' => { 'Enabled' => false }
          }
          file.write(user_config.to_yaml)
          file.flush

          config = described_class.load(file.path)
          expect(config['PostgreSQL']['Enabled']).to eq(false)
          expect(config['Default/SelectWithoutLimit']['Enabled']).to eq(false)
          expect(config['MySQL']['Enabled']).to eq(true) # from default
        end
      end
    end
  end

  describe '#enabled?' do
    let(:config_hash) do
      {
        'Default' => { 'Enabled' => true },
        'PostgreSQL' => { 'Enabled' => false },
        'Default/SelectWithoutLimit' => { 'Enabled' => false }
      }
    end
    let(:config) { described_class.new(config_hash) }

    it 'returns false if category is disabled' do
      expect(config.enabled?('PostgreSQL/UnionWithoutAll')).to eq(false)
    end

    it 'returns false if specific checker is disabled' do
      expect(config.enabled?('Default/SelectWithoutLimit')).to eq(false)
    end

    it 'returns true if category and checker are enabled' do
      expect(config.enabled?('Default/OtherChecker')).to eq(true)
    end

    it 'returns true if checker is not specified but category is enabled' do
      expect(config.enabled?('Default/UnknownChecker')).to eq(true)
    end
  end
end
