module VVZUpdater
  class EventDateUpdater

    def initialize(source)
      @source = source.to_s
    end

    def db_room_cach
      @db_room_cach ||= Hash.new do |cache, room|
        cache[room] = find_or_create_room(room)
      end
    end

    def update(db_event, dates)
      all_existing_dates = db_event.dates
      existing_dates_m, new_dates = matches(dates, all_existing_dates)

      create(new_dates, db_event)
      update_many(existing_dates_m)

      removed = find_removable(existing_dates_m, all_existing_dates)
      EventDate.destroy(removed)
    end

    Match = Struct.new(:date, :db_date)
    def matches(dates, db_dates)
      matches = dates.map do |date|
        db_date = db_dates.find {|db_date| db_date.uuid == date.id}
        Match.new(date, db_date)
      end
      matches.partition {|d| d.db_date.present? }
      # [matching, no_match]
    end

    def find_removable(matches, existing_dates)
      existing_dates.select do |ed|
        matches.none? {|match| ed.uuid == match.date.id} && ed.source == @source
      end
    end

    def create(matches, db_event)
      attributes = matches.map {|match| attributes(match.date) }
      db_event.dates.create attributes
    end

    def update_many(matches)
      matches.each do |match|
        if allowed_to_update?(match.db_date)
          match.db_date.update_attributes(attributes(match.date))
        end
      end
    end

    def allowed_to_update?(db_date)
      db_date.source == @source || @source == :event_updater
    end

    def attributes(date)
      {
        uuid: date.id,
        start_time: date.start,
        end_time: date.end,
        api_last_modified: date.last_modified,
        room_id: date.room && find_room(date.room).id,
        data: {
          source: @source
        }
      }
    end

    def find_room(room)
      db_room_cach[room]
    end

    def find_or_create_room(room)
      Room.find_or_create_by_uuid!({
        uuid: room.id,
        name: room.title
      })
    end
  end
end

