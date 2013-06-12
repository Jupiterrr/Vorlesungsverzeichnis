class CorrectTimezones < ActiveRecord::Migration
  def up
    events = Event.where(term: "SS_2013")
    events.each do |event|
      event.dates.each do |event_date|
        event_date.update_attributes({
          start_time: date_with_new_timezone(event_date.start_time),
          end_time: date_with_new_timezone(event_date.end_time)
        })
      end
    end
  end

  def down
  end

  private

  def date_with_new_timezone(date)
    date.to_datetime.change(offset: "CEST") + 1.hour
  end

end
