require "kit_api"

require "vvz_updater/vvz_updater/tree_migration"
require "vvz_updater/vvz_updater/tree_diff"
require "vvz_updater/vvz_updater/tree_diff/pair_finder"
require "vvz_updater/vvz_updater/event_linker"
require "vvz_updater/vvz_updater/event_updater"
require "vvz_updater/vvz_updater/event_date_updater"

KitApi.logger.level = Logger::INFO

module VVZUpdater
  class << self

    def updater_tree(term)
      connection = KitApi::Connection.connect
      root = KitApi.get_tree(connection, term)

      uni = Vvz.university("KIT")
      db_root = uni.children.find_or_create_by_name(term)

      TreeMigration.new(db_root, root).migrate!
      connection.disconnect
    end

    Link = Struct.new(:db_leaf, :events)

    def link_events(term_name)
      connection = KitApi::Connection.connect

      term = Vvz.term("KIT", term_name)
      leafs = term.leafs

      queue = Queue.new

      processor = KitApi::QueueProcessor.new(30, leafs) do |leaf|
        events = KitApi.get_events_by_parent(connection, leaf.external_id)
        link = Link.new(leaf, events)
        queue << link
        link
      end

      worker = Thread.new {
        until queue.empty? && !processor.working? do
          link = queue.pop
          EventLinker.new(link.db_leaf, term_name).link(link.events)
        end
      }

      start = Time.now
      while processor.working? do
        print_report(processor, leafs, start)
        sleep 2
      end
      worker.join

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

    def print_report(processor, leafs, start)
      durations = processor.results.flat_map(&:duration)
      finished_jobs = leafs.count - processor.jobs

      job_duration = (Time.now - start) / finished_jobs
      time_prediction = job_duration * processor.jobs / 60

      probe = durations.last(10)
      av_druation = probe.count == 0 ? 0 : probe.inject(:+).to_f / probe.count

      rq_duration = (Time.now - start) / processor.results.count

      progress = ("%3i" % finished_jobs) + "/"  + leafs.count.to_s
      prediction = ("%5.1f" % time_prediction) + "m"
      rq_speed = ("%4.1f" % rq_duration) + "s"
      job_speed = ("%4.1f" % av_druation) + "s"
      rqs = "%4i" % processor.results.count

      print 13.chr
      # col=$(tput cols)
      # printf '%s%*s%s' "$GREEN" $col "[OK]" "$NORMAL"
      print "[#{processor.count}] #{progress}  ~ #{prediction}   |   #{job_speed} per job   | #{rqs} rqs @#{rq_speed}"
    end


    def update_events(term_name)
      connection = KitApi::Connection.connect

      term = Vvz.term("KIT", term_name)
      external_ids = Event.where(term: term_name).order("RANDOM()").pluck(:external_id) #.limit(10)
      queue = Queue.new

      processor = KitApi::QueueProcessor.new(20, external_ids) do |external_id|
        begin
          event = KitApi.get_event(connection, external_id)
          queue << [external_id, event]
          event
        rescue KitApi::Parser::ResponseEmpty
          puts "Response empty, #{external_id}"
        end
      end

      worker = Thread.new {
        Thread.abort_on_exception = true
        while !queue.empty? || processor.working? do
          if queue.empty?
            sleep 1
          else
            external_id, event = queue.pop
            db_event = Event.find_by_external_id(external_id)
            EventUpdater.new(db_event).update(event)
            puts db_event.id
          end
        end
      }

      start = Time.now
      while processor.working? do
        #print_report(processor, external_ids, start)
        sleep 2
      end
      worker.join

      connection.disconnect
    end

    # def update_event(id)
    #   connection = KitApi::Connection.connect

    #   db_event = Event.find(id)
    #   event = KitApi.get_event(connection, db_event.external_id)

    #   EventUpdater.new(db_event).update(event)

    #   connection.disconnect
    # end

  end
end
