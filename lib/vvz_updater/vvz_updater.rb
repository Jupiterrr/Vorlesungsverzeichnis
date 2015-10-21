require "kit_api"

require "vvz_updater/vvz_updater/tree_migration"
require "vvz_updater/vvz_updater/tree_diff"
require "vvz_updater/vvz_updater/event_linker"
require "vvz_updater/vvz_updater/event_updater"
require "vvz_updater/vvz_updater/event_date_updater"
require "vvz_updater/vvz_updater/data_enhancement"
# require "vvz_updater/vvz_updater/package_update"
require "vvz_updater/vvz_updater/migration"
require "vvz_updater/vvz_updater/node"
require 'tmpdir'

# KitApi.logger.level = Logger::INFO

# require "pry"

module VVZUpdater

  class << self

    def update(term)
      puts "start migration #{term}"
      update_tree(term)
      update_events(term)
      improve_names(term)

      puts "done."
    end

    def update_tree(term)
      puts "load tree"
      tree = KitApi::Client.new.get_tree(term)
      root = parse_node(tree)

      puts "start TreeMigration"
      db_root = get_db_term(term)
      TreeMigration.new(db_root, root).migrate!
      # db_root.update_attribute(:name, term)
    end

    def update_events(term)
      puts "load events"
      events = KitApi::Client.new.get_all_events(term).to_a
      puts "start EventUpdater"
      EventUpdater.run!(term, events)
      puts "start EventDateUpdater"
      EventDateUpdater.run!(term, events)
      puts "start EventLinker"
      EventLinker.run!(term, events)
    end

    # def exists?(term)
    #   terms = KitApi::Client.new.get_terms.map(&:name)
    #   terms.include?("SS 2015")
    # end

    # def convert_term_name(name)
    #   term = name[0..1]
    #   if term == "SS"
    #     name
    #   else
    #     "#{term} 20#{name[3..4]}"
    #   end
    # end

    def improve_names(term_name)
      puts "improving names"
      DataEnhancer.new(term_name).improve_names()
    end

    class Node < Struct.new(:id, :name, :children)

      def child_ids
        children.map(&:id)
      end

      def external_id
        id
      end

      def is_leaf?
        children.empty?
      end

      def as_json
        base = {id: id, name: name}
        base[:children] = children.map(&:as_json)
        base
      end

      def flatten(nodes=[])
        nodes << self
        children.each {|child| child.flatten(nodes) }
        nodes
      end

      def leafs(nodes=[])
        if is_leaf?
          nodes << self
        else
          children.map {|child| child.leafs(nodes) }
        end
        nodes
      end

      # def term_name
      #   if name.include?("/")
      #     term, y = name.match(/(..)\s(\d+)/).captures
      #     "#{term} 20#{y}"
      #   else
      #     name
      #   end
      # end

    end


    def parse_node(node)
      Node.new(
        node.id,
        node.name,
        node.children.map {|h| parse_node(h) }
      )
    end

    def get_db_term(term)
      uni = Vvz.find_or_create_by_name("KIT")
      db_root = uni.children.find_or_create_by_name(term)
    end


    # Sets the logger to use.
    attr_accessor :logger

    # Returns the logger. Defaults to an instance of +Logger+ writing to STDOUT.
    def logger
      @logger ||= ::Logger.new($stdout)
    end

    # Logs a given +message+.
    def log(log_level, message)
      logger.send(log_level, message)
    end

    # def load_events(dir)
    #   files = Dir[File.join(dir, "events", "*.json")]
    #   files.map do |file_path|
    #     json = File.read(file_path)
    #     hash = JSON.parse(json)
    #   end
    # end

  end
end
