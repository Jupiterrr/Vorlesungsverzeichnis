module VVZUpdater
  class PackageUpdate

    attr_reader :package_path

    def initialize(package_path)
      @package_path = package_path
    end

    # Node = Struct.new(:external_id, :name, :children, :event_ids)

    def run
      logger.info "load package from #{package_path}"
      Dir.mktmpdir {|tmp_dir|
        dir = untar(package_path, tmp_dir)
        root = load_tree(dir)
        term = root.term_name
        events = load_events(dir)
        VVZUpdater::Migration.new(term, tree: root, events: events).run
      }
      logger.info "done"
    end

    # def download_term(url, target)
    #   `curl -o #{target} #{url}`
    # end

    def untar(package_path, tmp_dir)
      logger.info "unpacking #{package_path}"
      `tar -xzf '#{package_path}' -C #{tmp_dir}`
      dir = Dir[File.join(tmp_dir, "*")].first
    end

    def load_tree(dir)
      logger.info "load tree"
      tree_json = File.read(File.join(dir, "tree.json"))
      tree_hash = JSON.parse(tree_json)
      tree = parse_node(tree_hash)
    end

    def parse_node(tree_hash)
      VVZUpdater::Node.new(
        tree_hash.fetch("id"),
        tree_hash.fetch("name"),
        tree_hash.fetch("children", []).map {|h| parse_node(h) },
        tree_hash.fetch("event_ids", []),
      )
    end

    def load_events(dir)
      logger.info "load events"
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

    def logger
      VVZUpdater.logger
    end

  end
end
