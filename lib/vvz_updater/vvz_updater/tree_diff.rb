module VVZUpdater
  class TreeDiff

    def self.diff(db_node, new_node)
      changes = []

      if  new_node.name != db_node.name
        changes << Change.new(:change, nil, [db_node, new_node])
      end

      finder = PairFinder.new(db_node.children, new_node.children)
      finder.search!

      # handle unmachted
      finder.unmatched.each do |node|
        type = node.new_record? ? :new : :delete
        changes << Change.new(type, db_node, node)
      end

      # handle pairs
      finder.pairs.each do |db_node, new_node|
        # check children
        changes << diff(db_node, new_node)
      end

      changes.flatten
    end

    class Change < Struct.new(:type, :parent, :node); end

  end
end

require_relative "tree_diff/pair_finder"
