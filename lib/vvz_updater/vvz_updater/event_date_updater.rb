module VVZUpdater
  class EventDateUpdater

    def initialize(term)
      # @source = source.to_s
      @term = term
    end

    def run!(events)
      @event_index = get_event_index()
      dates = get_dates(events)
      puts "create room index"
      @room_index = get_room_index(dates)
      # puts "setup date grouper"
      # grouper = DateGrouper.new(dates, existing_dates(events))
      # puts "delete"
      # delete(grouper.removed_db_dates)
      # puts "create"
      # create(grouper.new_dates)
      # puts "update"
      # update(grouper.existing_date_pairs)
      puts "delete all dates"
      existing_dates(events).delete_all
      puts "create"
      create(dates)
    end

    def self.run!(term, events)
      new(term).run!(events)
    end

    def get_dates(events)
      events.flat_map do |event|
        dates = event.fetch("dates")
        dates.each {|date| date["event_id"] = @event_index.fetch(event.fetch("id")) }
        dates
      end
    end

    def existing_dates(events)
      event_ids = events.map {|event| event.fetch("id")}
      EventDate.where(event_id: event_ids).select([:id, :uuid])
    end

    def create(dates)
      puts "prepare create"
      hashes = dates.map {|date| attributes(date) }
      puts "actually create"
      mass_insert(hashes)
      # EventDate.create(hashes)
    end

    def mass_insert(hashes)
      keys = hashes.first.keys.map(&:to_s)
      inserts = hashes.map do |data|
        items = data.values.map do |x|
          !x.nil? ? "'#{x}'" : "NULL"
        end.join(", ")
        "(#{items})"
      end
      sql = "INSERT INTO event_dates (#{keys.join(", ")}) VALUES #{inserts.join(", ")}"
      ActiveRecord::Base.connection.execute(sql)
    end

    # def delete(db_dates)
    #   # binding.pry
    #   # EventDate.destroy(db_dates) unless
    #   # db_dates.delete_all
    #   raise
    # end

    def update(pairs)
      zipped = pairs.map do |pair|
        [pair.db_node.id, attributes_hash(pair.node)]
      end
      ids, hashes = zipped.transpose
      EventDate.update(ids, hashes)
    end

    def attributes(date)
      start_time = Time.parse("#{date.fetch("start_time")} #{date.fetch("start_date")}")
      end_time = Time.parse("#{date.fetch("end_time")} #{date.fetch("end_date")}")
      room_id = date.fetch("room") ? date.fetch("room").fetch("id") : nil
      {
        uuid: date.fetch("id"),
        start_time: start_time,
        end_time: end_time,
        api_last_modified: date.fetch("last_modified"),
        room_id: @room_index[room_id],
        relation: date.fetch("relation"),
        event_id: date.fetch("event_id")
      }
    end

    def get_room_index(dates)
      create_rooms(dates)
      room_index = {}
      db_rooms = Room.select([:id, :uuid])
      db_rooms.each {|room| room_index[room.uuid] = room.id }
      room_index
    end

    def create_rooms(dates)
      rooms = dates.map {|date| date.fetch("room") }.compact
      db_rooms = Room.select([:id, :uuid])
      grouper = RoomGrouper.new(rooms, db_rooms)
      hashes = grouper.new_nodes.map {|room| room_attributes(room) }
      Room.create(hashes)
    end

    def room_attributes(room)
      {
        uuid: room.fetch("id"),
        name: room.fetch("name")
      }
    end

    def get_event_index()
      db_events = Event.where(term: @term).select([:id, :external_id])
      db_events.reduce({}) do |index, event|
        index[event.external_id] = event.id
        index
      end
    end

  end
end

require_relative "event_date_updater/value_set"
require_relative "event_date_updater/date_grouper"
require_relative "event_date_updater/room_grouper"
