require "spec_helper"
require './app/models/timetable'

describe Timetable do
  before do
    @now = DateTime.new(2013, 1, 1, 14, 0, 0).utc
    Timecop.freeze(@now)
  end

  after do
    Timecop.return
  end

  let(:event) { Event.create name: "Test Event" }
  let(:user) { FactoryGirl.create(:user) }

  before do
    @start = @now+2.hours
    event.dates.create start_time: @start, end_time: @start+3.hours
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
      user.events << event
    end
    it "returns dates with correct time" do
      ical = Timetable.to_ical(user.timetable_id)
      event = ical.events.first
      event.dtstart_property.to_datetime.should eq @start
    end
  end
end