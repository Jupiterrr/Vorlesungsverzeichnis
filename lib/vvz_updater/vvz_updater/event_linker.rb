module VVZUpdater
  class EventLinker

    def initialize(db_leaf, term_name)
      @db_leaf = db_leaf
      @term_name = term_name
      @date_updater = EventDateUpdater.new(:linker)
    end

    def link(events)
      @db_leaf.events.clear
      db_events = events.map {|event| update(event) }
      @db_leaf.events << db_events
    end

    def update(event)
      db_event = find_or_create(event)
      db_event.update_attributes({
        linker_attributes: {
          last_run: Time.now
        }
      })
      @date_updater.update(db_event, event.dates)
      db_event
    end

    def find_or_create(event)
      Event.find_or_create_by_external_id({
        external_id: event.external_id,
        term: @term_name
      })
    end

  end
end
