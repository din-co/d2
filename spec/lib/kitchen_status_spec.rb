require 'rails_helper'

RSpec.describe KitchenStatus do
  describe 'time calculation' do
    examples = [
      {
        current_time:          Time.zone.parse('Sun, 17 Jan 2016 00:00'),

        opening_time:          Time.zone.parse('Sun, 17 Jan 2016 00:00'),
        shipment_opening_time: Time.zone.parse('Mon, 18 Jan 2016 00:00'),
        closing_time:          Time.zone.parse('Tue, 19 Jan 2016 12:00'),
        shipment_closing_time: Time.zone.parse('Wed, 20 Jan 2016 12:00'),

        next_opens:            Time.zone.parse('Sun, 24 Jan 2016 00:00'),
        shipment_dates_available: 3,
      },

      {
        current_time:          Time.zone.parse('Mon, 18 Jan 2016 00:00'),

        opening_time:          Time.zone.parse('Sun, 17 Jan 2016 00:00'),
        shipment_opening_time: Time.zone.parse('Mon, 18 Jan 2016 00:00'),
        closing_time:          Time.zone.parse('Tue, 19 Jan 2016 12:00'),
        shipment_closing_time: Time.zone.parse('Wed, 20 Jan 2016 12:00'),

        next_opens:            Time.zone.parse('Sun, 24 Jan 2016 00:00'),
        shipment_dates_available: 2,
      },

      {
        # last second ordering is still open
        current_time:          Time.zone.parse('Tue, 19 Jan 2016 20:59:59'),

        opening_time:          Time.zone.parse('Sun, 17 Jan 2016 00:00'),
        shipment_opening_time: Time.zone.parse('Mon, 18 Jan 2016 00:00'),
        closing_time:          Time.zone.parse('Tue, 19 Jan 2016 12:00'),
        shipment_closing_time: Time.zone.parse('Wed, 20 Jan 2016 12:00'),

        next_opens:            Time.zone.parse('Sun, 24 Jan 2016 00:00'),
        shipment_dates_available: 0,
      },

      {
        current_time:          Time.zone.parse('Wed, 20 Jan 2016 00:00'),

        opening_time:          Time.zone.parse('Sun, 17 Jan 2016 00:00'),
        shipment_opening_time: Time.zone.parse('Mon, 18 Jan 2016 00:00'),
        closing_time:          Time.zone.parse('Tue, 19 Jan 2016 12:00'),
        shipment_closing_time: Time.zone.parse('Wed, 20 Jan 2016 12:00'),

        next_opens:            Time.zone.parse('Sun, 24 Jan 2016 00:00'),
        shipment_dates_available: 0,
      },

      {
        current_time:          Time.zone.parse('Sat, 23 Jan 2016 00:00'),

        opening_time:          Time.zone.parse('Sun, 17 Jan 2016 00:00'),
        shipment_opening_time: Time.zone.parse('Mon, 18 Jan 2016 00:00'),
        closing_time:          Time.zone.parse('Tue, 19 Jan 2016 12:00'),
        shipment_closing_time: Time.zone.parse('Wed, 20 Jan 2016 12:00'),

        next_opens:            Time.zone.parse('Sun, 24 Jan 2016 00:00'),
      },

      {
        current_time:          Time.zone.parse('Sun, 24 Jan 2016 00:00'),

        opening_time:          Time.zone.parse('Sun, 24 Jan 2016 00:00'),
        shipment_opening_time: Time.zone.parse('Mon, 25 Jan 2016 00:00'),
        closing_time:          Time.zone.parse('Tue, 26 Jan 2016 12:00'),
        shipment_closing_time: Time.zone.parse('Wed, 27 Jan 2016 12:00'),

        next_opens:            Time.zone.parse('Sun, 31 Jan 2016 00:00'),
      },

      {
        current_time:          Time.zone.parse('Mon, 25 Jan 2016 00:00'),

        opening_time:          Time.zone.parse('Sun, 24 Jan 2016 00:00'),
        shipment_opening_time: Time.zone.parse('Mon, 25 Jan 2016 00:00'),
        closing_time:          Time.zone.parse('Tue, 26 Jan 2016 12:00'),
        shipment_closing_time: Time.zone.parse('Wed, 27 Jan 2016 12:00'),

        next_opens:            Time.zone.parse('Sun, 31 Jan 2016 00:00'),
      },
    ]
    examples.each do |ex|
      it "indicates correct opening time when current time is #{ex[:current_time]}" do
        ks = described_class.new
        Timecop.travel(ex[:current_time]) do
          expect(ks.opening_time).to eql(ex[:opening_time])
        end
      end
      it "indicates correct closing time when current time is #{ex[:current_time]}" do
        ks = described_class.new
        Timecop.travel(ex[:current_time]) do
          expect(ks.closing_time).to eql(ex[:closing_time])
        end
      end
      it "indicates correct next opening time when current time is #{ex[:current_time]}" do
        ks = described_class.new
        Timecop.travel(ex[:current_time]) do
          expect(ks.next_opens).to eql(ex[:next_opens])
        end
      end
      it "indicates correct shipment opening time when current time is #{ex[:current_time]}" do
        ks = described_class.new
        Timecop.travel(ex[:current_time]) do
          expect(ks.next_opens).to eql(ex[:next_opens])
        end
      end
      it "indicates correct shipment closing time when current time is #{ex[:current_time]}" do
        ks = described_class.new
        Timecop.travel(ex[:current_time]) do
          expect(ks.next_opens).to eql(ex[:next_opens])
        end
      end
    end
  end

  it 'is open between opening_time and closing_time, and not open before or after' do
    ks = described_class.new
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