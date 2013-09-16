module VVZUpdater
  class EventDateUpdater

    def initialize(source)
      @source = source.to_s
    end


    def update(db_event, dates)
      all_existing_dates = db_event.dates

      existing_dates = all_existing_dates.select do |date|
        # destroy if it has no source
        date.destroy if date.data["source"].nil?
        date.data["source"] == @source
      end

      new_dates = []
      updated_dates = []

      dates.each do |date|
        db_date = existing_dates.find {|ed| ed.uuid == date.id}
        if db_date.nil?
          db_date = EventDate.new(uuid: date.id)
          new_dates << db_date
        end
        update_date(db_date, date)
        updated_dates << db_date
      end

      db_event.dates << new_dates

      removed_dates = (existing_dates - updated_dates)
      EventDate.destroy(removed_dates)

    end

    def update_date(db_date, date)
      # return if db_date.api_last_modified >= date.last_modified
      db_date.update_attributes({
        room: date.room.title,
        start_time: date.start,
        end_time: date.end,
        api_last_modified: date.last_modified,
        data: {
          room_id: date.room.id,
          source: @source
        }
      })
    end

  end
end
