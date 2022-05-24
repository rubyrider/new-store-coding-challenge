# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StorageSupport do
  FakeTable = Class.new do
    attr_accessor :fake_column
  end

  before { FakeTable.include StorageSupport }

  describe '#update' do
    context 'with valid column' do
      let(:table) { FakeTable.new }

      it 'is expected to update table column with updated_at timestamp' do
        expect { table.update(fake_column: 'FakeValue') }.to change { table.updated_at }
      end
    end

    context 'with invalid column' do
      let(:table) { FakeTable.new }

      it 'is expected to raise concern/exception' do
        expect { table.update(unavailable_column: 'FakeValue') }.to raise_error NoMethodError
      end
    end
  end
end
