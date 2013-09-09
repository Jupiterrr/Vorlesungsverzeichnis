module VVZUpdater
  class TreeDiff
    # This class tries to merge an array of db_node and and an array of new_nodes
    # based on there external_id.
    #
    # Example:
    #
    #   merger = NodeMerger.new([existing1, existing2], [new])
    #   merger.merge!
    #   merger.remaining_existing_nodes
    #   # => [existing2]
    #
    # Results can be accessed throug :matches, :remaining_existing_nodes, :remaining_new_nodes
    class PairFinder

      attr_reader :pairs, :unmatched

      def initialize(existing_nodes, new_nodes)
        @existing_nodes = existing_nodes
        @new_nodes = new_nodes
      end

      def existing_node_index
        index = {}
        @existing_nodes.each {|a| index[a.external_id] = a }
        index
      end

      # Find pairs of existing and new nodes based on their external_id.
      # Returns an array of "pairs".
      # A pair can be:
      #   match: [existing_node, new_node]
      #   new node without a match: [nil, new_node]
      #   existing node without a match: [existing_node, nil]
      def search!
        @pairs = find_pairs
        @unmatched = get_unused(@pairs)
      end

      def find_pairs
        index = existing_node_index
        @new_nodes.map do |new_node|
          if existing = index[new_node.external_id]
            [existing, new_node]
          end
        end.compact
      end

      def get_unused(pairs)
        used_existing = pairs.map(&:first)
        unused_existing = @existing_nodes - used_existing
        used_new = pairs.map(&:second)
        unused_new = @new_nodes - used_new
        [*unused_existing, *unused_new]
      end

    end
  end
end