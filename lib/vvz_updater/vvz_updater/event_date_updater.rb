module VVZUpdater
  class EventDateUpdater

    def initialize(source)
      @source = source.to_s
    end


    def update(db_event, dates)
      existing_dates = db_event.dates
      own, other = existing_dates.partition {|d| d.source == @source}

      new_dates = []
      updated_dates = []

      dates.each do |date|
        db_date = existing_dates.find {|ed| ed.uuid == date.id}
        case
        when db_date.present? && db_date.source == @source
          db_date.update_attributes(attributes(date))
          updated_dates << db_date
        when !db_date.present?
          new_dates << EventDate.create(attributes(date))
        else
          # present but other source
        end
      end

      db_event.dates << new_dates

      unchanged_own = (own - updated_dates)
      EventDate.destroy(unchanged_own)
    end

    def attributes(date)
      {
        uuid: date.id,
        room: date.room.title,
        start_time: date.start,
        end_time: date.end,
        api_last_modified: date.last_modified,
        data: {
          room_id: date.room.id,
          source: @source
        }
      }
    end

  end
end
