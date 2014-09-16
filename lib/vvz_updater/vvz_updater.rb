# require "kit_api"
# require 'celluloid'

require "vvz_updater/vvz_updater/tree_migration"
require "vvz_updater/vvz_updater/tree_diff"
require "vvz_updater/vvz_updater/event_linker"
require "vvz_updater/vvz_updater/event_updater"
require "vvz_updater/vvz_updater/event_date_updater"
require "vvz_updater/vvz_updater/data_enhancement"
require 'tmpdir'
# require "pry"
require 'json'
# KitApi.logger.level = Logger::INFO


module VVZUpdater

  Node = Struct.new(:external_id, :name, :children, :event_ids)

  class << self

    def improve_names(term_name)
      puts "improving names"
      DataEnhancer.new(term_name).improve_names()
    end

    def download_term(url, target)
      `curl -o #{target} #{url}`
    end

    def load_term(package_path)
      puts "start migration from #{package_path}"
      Dir.mktmpdir {|tmp_dir|
        dir = untar(package_path, tmp_dir)
        root = load_tree(dir)
        term = root.term_name
        mirgrate_tree!(root, term)
        update_events!(dir, term)
        link_events!(root, term)
        improve_names(term)
      }
      puts "done."
    end

    def untar(package_path, tmp_dir)
      puts "unpacking #{package_path}"
      `tar -xzf '#{package_path}' -C #{tmp_dir}`
      dir = Dir[File.join(tmp_dir, "*")].first
    end

    def load_tree(dir)
      tree_json = File.read(File.join(dir, "tree.json"))
      tree_hash = JSON.parse(tree_json)
      tree = parse_node(tree_hash)
    end

    class Node < Struct.new(:id, :name, :children, :event_ids)

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
        if is_leaf?
          base[:event_ids] = event_ids
        else
          base[:children] = children.map(&:as_json)
        end
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

      def term_name
        if name.include?("/")
          term, y = name.match(/(..)\s(\d+)/).captures
          "#{term} 20#{y}"
        else
          name
        end
      end

    end


    def parse_node(tree_hash)
      Node.new(
        tree_hash.fetch("id"),
        tree_hash.fetch("name"),
        tree_hash.fetch("children", []).map {|h| parse_node(h) },
        tree_hash.fetch("event_ids", []),
      )
    end

    def mirgrate_tree!(root, term)
      puts "start TreeMigration"
      db_root = get_db_term(term)
      TreeMigration.new(db_root, root).migrate!
      db_root.update_attribute(:name, term)
    end

    def get_db_term(term)
      uni = Vvz.find_or_create_by_name("KIT")
      db_root = uni.children.find_or_create_by_name(term)
    end

    def link_events!(root, term)
      puts "start EventLinker"
      EventLinker.run!(term, root.leafs)
    end

    def update_events!(dir, term)
      puts "load events"
      events = load_events(dir)
      puts "start EventUpdater"
      EventUpdater.run!(term, events)
      puts "start EventDateUpdater"
      EventDateUpdater.run!(term, events)
    end

    def load_events(dir)
      files = Dir[File.join(dir, "events", "*.json")]
      files.map do |file_path|
        json = File.read(file_path)
        hash = JSON.parse(json)
      end
    end

    # def mem_debug
    #   require "pp"
    #   objects = Hash.new(0)
    #   ObjectSpace.each_object{|obj| objects[obj.class] += 1 }
    #   pp objects.sort_by{|k,v| -v}
    #   #ap objects[KitApi::EventParser::Date]
    # end

  end
end
