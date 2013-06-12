require "vcr_helper"
require './lib/week_timetable/week_timetable'
require 'active_support/all'

describe WeekTimetable::WeekMapper do
  before do
    Timecop.freeze(DateTime.now.utc)
  end

  it "maps to correct new date" do
    week = DateTime.new(2013, 1, 1)
    time = DateTime.new(2013, 1, 2+7, 11, 0)
    new_date = subject.map_date_to_week(time, week)
    new_date.should == DateTime.new(2013, 1, 2, 11, 0)
  end

  it "maps to correct timezone" do
    week = DateTime.new(2013, 1, 7)
    time = DateTime.new(2013, 1, 7+7, 11, 0, 0, '+2')
    new_date = subject.map_date_to_week(time, week)
    new_date.should == DateTime.new(2013, 1, 7, 11, 0, 0, '+2')
  end

  after do
    Timecop.return
  end
end
