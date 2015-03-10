module VVZUpdater
  class EventLinker

    def initialize(term)
      @term = term
    end

    def run!(events)
      nodes = Vvz.term("KIT", @term).subtree
      @db_event_index = event_index()
      @db_leaf_index = vvz_index(nodes)
      mass_delete(nodes)
      pairs = events.flat_map(&method(:get_links))
      mass_insert(pairs)
    end

    def self.run!(term, leafs)
      new(term).run!(leafs)
    end

    private

    def mass_insert(pairs)
      values = pairs.map {|pair| "(#{pair.vvz_id}, #{pair.event_id})"}.join(", ")
      sql = "INSERT INTO events_vvzs (vvz_id, event_id) VALUES #{values}"
      ActiveRecord::Base.connection.execute(sql)
    end

    def mass_delete(db_leafs)
      vvz_ids = db_leafs.map(&:id).join(", ")
      sql = "DELETE FROM events_vvzs WHERE vvz_id IN (#{vvz_ids})"
      ActiveRecord::Base.connection.execute(sql)
    end

    def get_links(event_hash)
      event_hash.fetch(:heading).map do |heading|
        event_id = @db_event_index.fetch(event_hash.fetch(:id))
        vvz_id = @db_leaf_index.fetch(heading.fetch(:id)) do
          VVZUpdater.logger.warn("Matching leaf not found! event: #{event_id}")
          nil
        end
        next if vvz_id.nil?
        Link.new(vvz_id, event_id)
      end.compact
    end

    def event_index()
      db_events = Event.where(term: @term).select([:id, :external_id])
      db_events.reduce({}) do |index, event|
        index[event.external_id] = event.id
        index
      end
    end

    def vvz_index(leafs)
      leafs.reduce({}) do |index, db_leaf|
        index[db_leaf.external_id] = db_leaf.id
        index
      end
    end

    Link = Struct.new(:vvz_id, :event_id)

  end
end
