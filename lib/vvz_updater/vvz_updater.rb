require "kit_api"
require 'celluloid/autostart'

require "vvz_updater/vvz_updater/tree_migration"
require "vvz_updater/vvz_updater/tree_diff"
require "vvz_updater/vvz_updater/tree_diff/pair_finder"
require "vvz_updater/vvz_updater/event_linker"
require "vvz_updater/vvz_updater/event_updater"
require "vvz_updater/vvz_updater/event_date_updater"
require "vvz_updater/vvz_updater/data_enhancement"

KitApi.logger.level = Logger::INFO

module VVZUpdater
  class << self

    def improve_names(term_name)
      DataEnhancement.improve_names(term_name)
    end

    def updater_tree(term)
      connection = KitApi::Connection.connect
      root = KitApi.get_tree(connection, term)

      uni = Vvz.university("KIT")
      db_root = uni.children.find_or_create_by_name(term)

      TreeMigration.new(db_root, root).migrate!
      connection.disconnect
    end



    class Reporter
      include Celluloid
      attr_reader :fired, :timer

      def initialize(r)
        @start = Time.now
        every(1) { print_r }
        @r = r
      end

      def print_r
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
        print 13.chr
        print "#{progress}  ~ #{prediction}  ~  #{rqs}rqs  -  #{destroyed_events}"
      end

    end




    Link = Struct.new(:db_leaf, :events)

    class LinkGetter
      include Celluloid

      def initialize(connection)
        @connection = connection
      end

      def get_link(leaf)
        events = KitApi.get_events_by_parent(@connection, leaf.external_id)
        link = Link.new(leaf, events)
      end

    end



    def link_events(term_name)
      connection = KitApi::Connection.connect
      term = Vvz.term("KIT", term_name)
      leafs = term.leafs

      # reporter
      r = {
        done: 0,
        jobs: leafs.count,
        connection: connection
      }
      reporter = Reporter.new(r)

      pool = LinkGetter.pool(size: 30, args: [connection])

      futures = leafs.map { |leaf| pool.future.get_link(leaf) }

      futures.each do |future|
        link = future.value
        EventLinker.new(link.db_leaf, term_name).link(link.events)
        r[:done] += 1
      end

      connection.disconnect
    end



    def update_event(db_event)
      connection = KitApi::Connection.connect

      # linker
      db_leaf = db_event.vvzs.first
      events = KitApi.get_events_by_parent(connection, db_leaf.external_id)
      linker_event = events.find {|e| e.external_id == db_event.external_id}
      EventLinker.new(db_leaf, db_leaf.term.name).update(linker_event)

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
      connection = KitApi::Connection.connect
      term = Vvz.term("KIT", term_name)
      uuids = Event.where(term: term_name).order("RANDOM()").pluck(:external_id)

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
        uuid, event = future.value
        db_event = Event.find_by_external_id(uuid)
        if event
          EventUpdater.new(db_event).update(event)
        else
          r[:destroyed] << db_event.destroy
        end
        r[:done] += 1
      end

      connection.disconnect
    end


    # def print_report(processor, leafs, start)
    #   durations = processor.results.flat_map(&:duration)
    #   finished_jobs = leafs.count - processor.jobs

    #   job_duration = (Time.now - start) / finished_jobs
    #   time_prediction = job_duration * processor.jobs / 60

    #   probe = durations.last(10)
    #   av_druation = probe.count == 0 ? 0 : probe.inject(:+).to_f / probe.count

    #   rq_duration = (Time.now - start) / processor.results.count

    #   progress = ("%3i" % finished_jobs) + "/"  + leafs.count.to_s
    #   prediction = ("%5.1f" % time_prediction) + "m"
    #   rq_speed = ("%4.1f" % rq_duration) + "s"
    #   job_speed = ("%4.1f" % av_druation) + "s"
    #   rqs = "%4i" % processor.results.count

    #   print 13.chr
    #   # col=$(tput cols)
    #   # printf '%s%*s%s' "$GREEN" $col "[OK]" "$NORMAL"
    #   print "[#{processor.count}] #{progress}  ~ #{prediction}   |   #{job_speed} per job   | #{rqs} rqs @#{rq_speed}"
    # end


  end
end
