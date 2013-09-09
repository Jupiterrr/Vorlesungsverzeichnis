module VVZUpdater
  class EventLinker

    def initialize(db_leaf, term_name)
      @db_leaf = db_leaf
      @term_name = term_name
    end

    def link(events)
      events.each {|event| link_single(event) }
    end

    def link_single(event)
      db_event = find_or_create(event)
      @db_leaf.events << db_event
    end

    def find_or_create(event)
      Event.find_or_create_by_external_id({
        external_id: event.external_id,
        linker_attributes: event.db_attributes,
        term: @term_name
      })
    end

  end
end