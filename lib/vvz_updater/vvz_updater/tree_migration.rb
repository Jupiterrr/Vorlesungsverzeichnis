module VVZUpdater
   class TreeMigration

      attr_reader :leafs

      def initialize(db_term, new_term)
         @new_term = new_term
         @db_term = db_term
      end

      def migrate!
         changes = TreeDiff.diff(@db_term, @new_term)
         changes.each do |change|
            case change.type
            when :new
               new_node(change.parent, change.node)
            when :change
               # in this case change.node is an Array
               # [db_node, new_node]
               changed_node(*change.node)
            when :delete
               deleted_node(change.node)
            else
               raise "Wrong change type!"
            end
         end
      end

      def new_node(db_parent, new_node)
         #puts "new"
         node = db_parent.children.create attributes(new_node)
         new_node.children.each do |child|
            new_node(node, child)
         end
      end

      def changed_node(db_node, new_node)
         #puts "change"
         db_node.update_attributes attributes(new_node)
      end

      def deleted_node(db_node)
         #puts "delete"
         db_node.subtree.delete_all
         db_node.delete
      end

      def attributes(new_node)
         {
            name: new_node.name,
            is_leaf: new_node.children.empty?
         }
      end

   end
end
