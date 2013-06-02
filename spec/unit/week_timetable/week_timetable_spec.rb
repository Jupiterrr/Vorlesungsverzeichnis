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

describe WeekTimetable do

end
