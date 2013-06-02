require "vcr_helper"
require './lib/week_timetable/week_timetable'
require 'active_support/all'

def new_date(start_t, end_t, event_id=1)
  stub("EventDate", {
    start_time: start_t,
    end_time: end_t,
    event_id: event_id
  })
end

describe WeekTimetable::DatesReducer do
  before do
    @time1 = Time.local(2013, 1, 1, 11, 0)
    @time2 = Time.local(2013, 1, 1, 11, 30)
    @time3 = Time.local(2013, 1, 1, 12, 0)
    @time4 = Time.local(2013, 1, 2, 12, 0)
  end

  it "stores dates with different times" do
    subject.push new_date(@time1, @time2)
    subject.push new_date(@time1, @time3)
    subject.event_dates.should have(2).items
  end

  it "stores dates with different events but same time" do
    subject.push new_date(@time1, @time2, 1)
    subject.push new_date(@time1, @time2, 2)
    subject.event_dates.should have(2).items
  end

  it "does not stores dates with same events and same time" do
    subject.push new_date(@time1, @time2, 1)
    subject.push new_date(@time1, @time2, 1)
    subject.event_dates.should have(1).items
  end

  it "stores dates with same events and same time but different day" do
    subject.push new_date(@time1, @time3, 1)
    subject.push new_date(@time1, @time4, 1)
    subject.event_dates.should have(2).items
  end

end
