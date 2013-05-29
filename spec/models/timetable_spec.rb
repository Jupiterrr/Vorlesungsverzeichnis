require "vcr_helper"
require './app/models/timetable'
require 'active_support/all'

def day(start_time)
  index = start_time.wday # sunday = 0, monday = 1, ...
  index == 0 ? 6 : index - 1
end

def new_date(start_t, end_t)
  stub "EventDate", start_time: start_t, end_time: end_t, day: day(start_t)
end

describe Timetable do

  #subject { Timetable.new events }

  describe ".index" do
    let(:event) { stub("Event", id: 12) }
    it "returns correct index_key" do
      date1 = new_date(Time.local(2013, 1, 1, 11, 0), Time.local(2013, 1, 1, 11, 30))
      subject.index_key(event, date1).should == "12 Tuesday 11:00 Tuesday 11:30"

      date2 = new_date(Time.local(2013, 1, 8, 11, 0), Time.local(2013, 1, 1, 11, 30))
      subject.index_key(event, date2).should == "12 Tuesday 11:00 Tuesday 11:30"

      date2 = new_date(Time.local(2013, 1, 7, 0, 0), Time.local(2013, 1, 7, 1, 15))
      subject.index_key(event, date2).should == "12 Monday 00:00 Monday 01:15"
    end
  end

  describe ".add_date" do
    let(:event) { stub("Event", id: 12) }

    it "adds event_dates" do
      date1 = new_date(Time.local(2013, 1, 1, 11, 0), Time.local(2013, 1, 1, 11, 30)) # tuesday
      date2 = new_date(Time.local(2013, 1, 7, 0, 0), Time.local(2013, 1, 7, 1, 15)) # monday

      subject.add_date event, date1
      subject.add_date event, date2
      subject.week[1].at(11).first[:date].should eql date1
      subject.week[0].at(0).first[:date].should eql date2
    end
    it "adds only new dates" do
      date1 = new_date(Time.local(2013, 1, 1, 11, 00), Time.local(2013, 1, 1))
      date2 = new_date(Time.local(2013, 1, 7, 11, 00), Time.local(2013, 1, 7))

      subject.add_date event, date1
      subject.add_date event, date2
      events = subject.week[1].at(11)
      events.count.should == 1
      events.first[:date].should eql date1
    end
  end

  describe "#map_wday_to_current_week" do

    it "maps to correct date" do
      now = Time.now
      time = now + 14.days
      new_time = Timetable.map_wday_to_current_week(time)
      now.should be_same_second_as(new_time)
    end

  end

end