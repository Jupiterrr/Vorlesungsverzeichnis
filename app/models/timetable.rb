class Timetable
  attr_reader :week

  class Day
    attr_reader :name
    def initialize(name)
      @name = name
      @hours = {}
    end

    def at(i)
      @hours.fetch(i)
    end

    def push(item)
      hour = item.date.start_time.hour
      @hours[hour] ||= []
      @hours[hour].push item
    end
  end

  class Item < Struct.new(:event, :date); end

  def initialize(events=[])
    @week = []
    @items = []
    days = %W(Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag)
    days.each {|name| @week.push Day.new(name) }

    # @index is used to determin if an event already exists
    @index = []
    [*events].each do |event|
      event.dates.each { |date| add_date event, date }
    end
  end

  def add_date(event, event_date)
    #puts "add date"
    key = index_key(event, event_date)
    unless @index.include? key
      @index << key
      @items << Item.new(event, event_date)
      @week[event_date.day].push Item.new(event, event_date)
    end
  end

  def self.by_user(user)
    Timetable.new(user.events)
  end

  def timetable
    @week
  end

  def as_json
    @items.map do |item|
      event = item.event
      {
        "id" => event.id,
        "start" => js_time(item.date.start_time),
        "end" => js_time(item.date.end_time),
        "title" => event.name,
        "url" => event_url(event)
      }
    end
  end

  def event_url(event)
    vvz = event.vvzs.first
    Rails.application.routes.url_helpers.event_path(event)
  end

  def js_time(time)
    time = Timetable.map_wday_to_current_week(time)
    time.to_i*1000
  end

  def self.get_w_day(day)
    (day - 1) % 7
  end

  # maps the weekday index to a date in the current week
  def self.map_wday_to_current_week(time)
    now = Time.now
    new_time = time.change({
      month: now.month,
      day: now.monday.day + get_w_day(time.wday)
    })
    new_time
  end

  # Returns a string that is uniques for a given timeslot of a week
  # If there are two evens at the exact same time and
  # with the same duration, the same string is returned
  #
  # event_date = EventDate.new(
  #   Time.local(2013, 1, 1, 11, 0),
  #   Time.local(2013, 1, 1, 11, 30)
  # )
  # index_key(event_date) => "Tuesday 11:00 Tuesday 11:30"
  #
  def index_key(event, event_date)
    event.id.to_s + event_date.start_time.strftime(" %A %H:%M ") + event_date.end_time.strftime("%A %H:%M")
  end


  def self.to_ical(timetable_id)
    user = User.find_by_timetable_id timetable_id
    raise ActiveRecord::RecordNotFound if user.nil?
    events = user.events
    RiCal.Calendar do |cal|
      events.each do |event|
        event.dates.each do |date|
          cal.event do |e|
            e.summary     = event.name
            #event.description = "First US Manned Spaceflight\n(NASA Code: Mercury 13/Friendship 7)"
            e.dtstart     = date.start_time
            e.dtend       = date.end_time
            e.location    = date.room || ""
            e.url         = event.url
            #e.uid         = "#{event.id}@kit.edu"
          end
        end
      end
    end
  end

end