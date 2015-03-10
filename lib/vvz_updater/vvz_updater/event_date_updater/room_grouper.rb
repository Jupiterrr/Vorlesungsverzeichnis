module VVZUpdater
  class EventDateUpdater
    class RoomGrouper

      def initialize(nodes, db_nodes)
        @node_set = ValueSet.new(nodes) {|room| room.fetch(:id) }
        @db_node_set = ValueSet.new(db_nodes, &:uuid)
      end

      def new_nodes
        new_ids = @node_set - @db_node_set
        new_ids.map {|id| @node_set[id] }
      end

      # def removed_db_nodes
      #   removed_ids = @db_node_set - @node_set
      #   removed_ids.map {|id| @db_node_set[id] }
      # end

      # def node_pairs
      #   existing_ids = @node_set & @db_node_set
      #   existing_ids.map {|id| NodePair.new(@node_set[id], @db_node_set[id]) }
      # end

      NodePair = Struct.new(:node, :db_node)

    end
  end
end

