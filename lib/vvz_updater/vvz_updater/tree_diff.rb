module VVZUpdater
  class TreeDiff

    def self.diff(db_node, new_node)
      changes = []

      changes << changed_node(db_node, new_node)

      grouper = NodeGrouper.new(new_node.children, db_node.children)

      changes << new_nodes(grouper, db_node)
      changes << removed_db_nodes(grouper, db_node)
      changes << pair_changes(grouper)

      changes.flatten.compact
    end

    def self.changed_node(db_node, new_node)
      Change.new(:change, nil, [db_node, new_node]) if new_node.name != db_node.name
    end

    def self.new_nodes(grouper, db_parent)
      grouper.new_nodes.map do |node|
        Change.new(:new, db_parent, node)
      end
    end

    def self.removed_db_nodes(grouper, db_parent)
      grouper.removed_db_nodes.map do |db_node|
        Change.new(:delete, db_node, db_parent)
      end
    end

    def self.pair_changes(grouper)
      grouper.node_pairs.map do |pair|
        # check children
        diff(pair.db_node, pair.node)
      end
    end

    class Change < Struct.new(:type, :parent, :node); end

  end
end

require_relative "tree_diff/node_grouper"
