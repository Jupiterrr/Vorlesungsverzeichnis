require "kit_api"
require 'celluloid'

require "vvz_updater/vvz_updater/tree_migration"
require "vvz_updater/vvz_updater/tree_diff"
require "vvz_updater/vvz_updater/event_linker"
require "vvz_updater/vvz_updater/event_updater"
require "vvz_updater/vvz_updater/event_date_updater"
require "vvz_updater/vvz_updater/data_enhancement"

KitApi.logger.level = Logger::INFO

module VVZUpdater
  class << self

    def improve_names(term_name)
      VVZUpdater::DataEnhancer.new(term_name).improve_names()
    end

    def updater_tree(term)
      connection = KitApi::Connection.connect
      root = KitApi.get_tree(connection, term)

      uni = Vvz.find_or_create_by_name("KIT")
      db_root = uni.children.find_or_create_by_name(term)

      TreeMigration.new(db_root, root).migrate!
      connection.disconnect
    end



    class Reporter
      include Celluloid
      attr_reader :fired, :timer

      def initialize(r)
        @start = Time.now
        @instant_logging = false #!ENV["DYNO"].present?
        @log_timer = @instant_logging ? 1 : 5
        @timer = every(@log_timer) { print_r }
        @r = r
      end

      def print_r
        if @r[:done] >= @r[:jobs]
          @timer.cancel
          puts "end"
        end
        finished_jobs = @r[:done]
        leafs = @r[:jobs]
        connection = @r[:connection]

        duration = Time.now - @start
        job_duration = duration / finished_jobs
        time_prediction = job_duration * (leafs-finished_jobs) / 60

        progress = ("%3i" % finished_jobs) + "/"  + leafs.to_s
        prediction = ("%5.1f" % time_prediction) + "m"

        rqs = "%5.1f" % (connection.request_count / duration)
        destroyed_events = @r[:destroyed] ? ("%3i" % @r[:destroyed].count) : ""
        txt = "#{progress}  ~ #{prediction}  ~  #{rqs}rqs  -  #{destroyed_events}"
        if @instant_logging
          print 13.chr
          print txt
        else
          puts txt
        end
      end

    end




    Link = Struct.new(:leaf_external_id, :events)

    class LinkGetter
      include Celluloid

      def initialize(connection)
        @connection = connection
      end

      def get_link(leaf_external_id)
        events = KitApi.get_events_by_parent(@connection, leaf_external_id)
        link = Link.new(leaf_external_id, events)
      end

    end

    def mem_debug
      require "pp"
      objects = Hash.new(0)
      ObjectSpace.each_object{|obj| objects[obj.class] += 1 }
      pp objects.sort_by{|k,v| -v}
      #ap objects[KitApi::EventParser::Date]
    end

    def link_events(term_name)
      Celluloid.start
      connection = KitApi::Connection.connect
      term = Vvz.term("KIT", term_name)
      leaf_external_ids = term.leafs.pluck(:external_id)

      # reporter
      r = {
        done: 0,
        jobs: leaf_external_ids.count,
        connection: connection
      }
      reporter = Reporter.new(r)

      pool = LinkGetter.pool(size: 30, args: [connection])

      futures = leaf_external_ids.map { |leaf_eid| pool.future.get_link(leaf_eid) }

      futures.each do |future|
        link = future.value
        db_leaf = Vvz.find_by_external_id(link.leaf_external_id)
        EventLinker.new(db_leaf, term_name).link(link.events)
        r[:done] += 1
        link.events = nil
        link.leaf_external_id = nil
        GC.start
      end

      connection.disconnect
    end

    def update_event(db_event, use_linker=true)
      connection = KitApi::Connection.connect

      # linker
      if use_linker
        db_leaf = db_event.vvzs.first
        events = KitApi.get_events_by_parent(connection, db_leaf.external_id)
        linker_event = events.find {|e| e.external_id == db_event.external_id}
        EventLinker.new(db_leaf, db_leaf.term.name).update(linker_event)
      end

      # event updater
      updater_event = KitApi.get_event(connection, db_event.external_id)
      EventUpdater.new(db_event).update(updater_event)
      connection.disconnect
    end



    class EventGetter
      include Celluloid

      def initialize(connection)
        @connection = connection
      end

      def get_event(uuid)
        event = KitApi.get_event(@connection, uuid)
        [uuid, event]
      rescue KitApi::Parser::ResponseEmpty
        # puts "Response empty, #{uuid}"
        [uuid, nil]
      end

    end


    def update_events(term_name)
      Celluloid.start
      connection = KitApi::Connection.connect
      term = Vvz.term("KIT", term_name)
      uuids = Event.where(term: term_name).order("RANDOM()").pluck(:external_id)
      # uuids = Event.where(term: term_name).limit(20).pluck(:external_id)

      # reporter
      r = {
        done: 0,
        jobs: uuids.count,
        connection: connection,
        destroyed: []
      }

      reporter = Reporter.new(r)
      pool = EventGetter.pool(size: 30, args: [connection])

      futures = uuids.map { |uuid| pool.future.get_event(uuid) }

      futures.each do |future|
        value = future.value
        uuid, event = value
        db_event = Event.find_by_external_id(uuid)
        if event
          EventUpdater.new(db_event).update(event)
        else
          r[:destroyed] << db_event.destroy
        end
        r[:done] += 1
        value.clear
        GC.start
      end

      connection.disconnect
    end


  end
end
