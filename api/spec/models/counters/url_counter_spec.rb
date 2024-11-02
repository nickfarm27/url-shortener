require 'rails_helper'

RSpec.describe Counters::UrlCounter do
  # Clear memoized instance between tests
  after(:each) do
    described_class.instance_variable_set(:@instance, nil)
  end

  describe '.instance' do
    context 'when counter exists' do
      let!(:counter) { Counter.create!(name: 'urls', value: 0) }

      it 'returns the urls counter' do
        expect(described_class.instance).to eq(counter)
      end

      it 'memoizes the counter instance' do
        first_call = described_class.instance
        second_call = described_class.instance
        expect(first_call.object_id).to eq(second_call.object_id)
      end
    end

    context 'when counter does not exist' do
      before do
        Counter.where(name: 'urls').destroy_all
      end

      it 'returns nil' do
        expect(described_class.instance).to be_nil
      end
    end
  end

  describe '.increment!' do
    context 'when counter exists' do
      let!(:counter) { Counter.create!(name: 'urls', value: 0) }

      it 'increments the counter value' do
        initial_value = counter.value
        described_class.increment!
        expect(counter.reload.value).to eq(initial_value + 1)
      end

      it 'returns the counter instance' do
        result = described_class.increment!
        expect(result).to eq(counter)
      end
    end

    context 'when counter does not exist' do
      before do
        Counter.where(name: 'urls').destroy_all
      end

      it 'raises an error' do
        expect {
          described_class.increment!
        }.to raise_error(NoMethodError)
      end
    end
  end
end
