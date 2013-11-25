module VVZUpdater
  class EventDateUpdater

    def initialize(source)
      @source = source.to_s
    end

    def update(db_event, dates)
      grouper = DateGrouper.new(dates, db_event.dates)

      create(grouper.new_dates, db_event)
      update_many(grouper.existing_date_pairs)
      destroy(grouper.removed_db_dates)
    end

    def create(dates, db_event)
      attributes = dates.map {|date| attributes(date) }
      db_event.dates.create attributes
    end

    def update_many(pairs)
      pairs.each {|pair| update_pair(pair) }
    end

    def update_pair(pair)
      if allowed_to_update?(pair.db_date)
        pair.db_date.update_attributes(attributes(pair.date))
      end
    end

    def destroy(db_dates)
      remove = db_dates.select {|db_date| allowed_to_remove?(db_date) }
      EventDate.destroy(remove)
    end

    def allowed_to_update?(db_date)
      db_date.source.nil? || db_date.source == @source || @source == :event_updater
    end

    def allowed_to_remove?(db_date)
      db_date.source.nil? || db_date.source == @source
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

    def db_room_cach
      @db_room_cach ||= Hash.new do |cache, room|
        cache[room] = find_or_create_room(room)
      end
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

require_relative "event_date_updater/value_set"
require_relative "event_date_updater/date_grouper"
