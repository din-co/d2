require 'rails_helper'

RSpec.describe KitchenStatus do
  it 'is open between opening_time and closing_time, and not open before or after' do
    ks = described_class.new(nil)
    Timecop.travel(ks.opening_time - 1.second) do
      expect(ks).to_not be_open
    end
    Timecop.travel(ks.opening_time) do
      expect(ks).to be_open
    end
    Timecop.travel(ks.closing_time - 1.second) do
      expect(ks).to be_open
    end
    Timecop.travel(ks.closing_time + 1.second) do
      expect(ks).to_not be_open
    end
  end

  it 'responds to the override' do
    always_open = described_class.new('open')
    always_closed = described_class.new('closed')
    Timecop.travel(always_open.opening_time - 1.second) do
      expect(always_open).to be_open
      expect(always_closed).to_not be_open
    end
    Timecop.travel(always_open.opening_time) do
      expect(always_open).to be_open
      expect(always_closed).to_not be_open
    end
    Timecop.travel(always_open.closing_time - 1.second) do
      expect(always_open).to be_open
      expect(always_closed).to_not be_open
    end
    Timecop.travel(always_open.closing_time + 1.second) do
      expect(always_open).to be_open
      expect(always_closed).to_not be_open
    end
  end
end
