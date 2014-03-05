require "spec_helper"
# require './app/models/timetable'

describe Timetable do
  let!(:now) { DateTime.new(2013, 1, 1, 14, 0, 0) }

  before { Timecop.freeze(now) }
  after  { Timecop.return }

  let(:event) { Event.create name: "Test Event" }
  let(:user) { User.test_user }

  before do
    @start = now+2.hours
    @date = event.dates.create start_time: @start, end_time: @start+3.hours
  end

  describe "as_json" do
    it "returns correct time" do
      result = Timetable.new([event]).as_json

      result_event = result.first
      start_int = result_event["start"] / 1000
      result_start = Time.at(start_int).to_datetime

      result_start.should eql @start
    end
  end

  describe "to_cal" do
    before do
      event.subscribe(user)
    end
    it "returns dates with correct time" do
      ical = Timetable.to_ical(user.timetable_id)
      rical = RiCal.parse_string(ical).first
      event = rical.events.first
      event.dtstart_property.to_zulu_time.should == @start.utc
    end
  end
end
