module VVZUpdater
  class EventLinker

    # def self.link!(db_leaf, term_name, event_uids)
    #   EventLinker.new(db_leaf, term_name).link(event_uids)
    # end

    def initialize(term)
      @term = term
    end

    def run!(leafs)
      db_event_index = event_index()
      db_leaf_index = vvz_index(leafs)

      mass_delete(db_leaf_index.values)

      pairs = get_id_pairs(leafs, db_event_index, db_leaf_index)
      mass_insert(pairs)
    end

    def self.run!(term, leafs)
      new(term).run!(leafs)
    end

    def mass_insert(pairs)
      values = pairs.map {|pair| "(#{pair.join(", ")})"}.join(", ")
      sql = "INSERT INTO events_vvzs (vvz_id, event_id) VALUES #{values}"
      ActiveRecord::Base.connection.execute(sql)
    end

    def mass_delete(db_leafs)
      vvz_ids = db_leafs.map(&:id).join(", ")
      sql = "DELETE FROM events_vvzs WHERE vvz_id IN (#{vvz_ids})"
      ActiveRecord::Base.connection.execute(sql)
    end

    def get_id_pairs(leafs, db_event_index, db_leaf_index)
      leafs.flat_map do |leaf|
        event_uuids = leaf.event_ids
        event_ids = event_uuids.map {|uuid| db_event_index.fetch(uuid) }

        db_leaf = db_leaf_index.fetch(leaf.id)
        [db_leaf.id].product(event_ids)
      end
    end

    def event_index()
      db_events = Event.where(term: @term).select([:id, :external_id])
      db_events.reduce({}) do |index, event|
        index[event.external_id] = event.id
        index
      end
    end

    def vvz_index(leafs)
      leaf_ids = leafs.map {|leaf| leaf.id }
      db_leafs = Vvz.where(external_id: leaf_ids).select([:id, :external_id])
      db_leafs.reduce({}) do |index, db_leaf|
        index[db_leaf.external_id] = db_leaf
        index
      end
    end

  end
end
