# encoding: UTF-8
module VVZUpdater
   class EventUpdater

      def initialize(term)
        @term = term
        @connection = ActiveRecord::Base.connection
      end

      def existing_events
        Event.where(term: @term).select([:id, :external_id])
      end

      def run!(events)
        grouper = EventGrouper.new(events, existing_events)
        delete(grouper.removed_db_nodes)
        create(grouper.new_nodes)
        update(grouper.node_pairs)
      end

      def self.run!(term, events)
        self.new(term).run!(events)
      end

      def delete(db_events)
        Event.destroy(db_events)
      end

      def create(events)
        # hashes = events.map {|event| attributes_hash(event) }
        # Event.create(hashes)
        return if events.empty?
        hashes = events.map do |event|
          sql_event_value(event)
        end
        mass_insert(hashes)
      end

      def update(pairs)
        return if pairs.empty?
        sql = pairs.map do |pair|
          update_sql(pair.node, pair.db_node.id)
        end.join
        @connection.execute(sql)
      end

      def mass_insert(hashes)
        values = insert_values(hashes)
        keys = hashes.first.keys.map(&:to_s)
        sql = "INSERT INTO events (#{keys.join(", ")}) VALUES #{values.join(", ")}"
        @connection.execute(sql)
      end

      def insert_values(hashes)

        hashes.map do |hash|
          items = hash.values.map {|v| quote(v) }
          "(#{items.join(", ")})"
        end
      end

      def update_sql(event, id)
        event.delete(:created_at)
        "UPDATE events SET #{set_string(event)} WHERE events.id=#{id};"
      end

      def set_string(event)
        hash = sql_event_value(event)
        hash.map do |k,v|
          "#{k}=#{quote(v)}"
        end.join(", ")
      end

      def sql_event_value(event)
        attributes = attributes_hash(event)
        attributes[:data] = hash_to_hstore(attributes[:data])
        attributes[:created_at] = Time.now.to_s
        attributes[:updated_at] = Time.now.to_s
        attributes
      end

      def hash_to_hstore(hash)
        val = "___" + PgHstore.dump(hash)
        val
      end

      def quote(val)
        if val[0..2] == '___'
          val[0..2] = ''
          val
        else
          @connection.quote(val)
        end
      end

      def attributes_hash(event)
        hash = {
          no: event.fetch("nr")[4..-1],
          orginal_no: event.fetch("nr"),
          term: @term,
          _type: event.fetch("type"),
          lecturer: event.fetch("lecturer").map {|h| h.fetch("title") }.join(", "),
          #faculty: event.fetch("organizer"),
          external_id: event.fetch("id"),
          url: event.fetch("url"),
          original_name: event.fetch("name"),
          name: event.fetch("name"),
          data: {
            sws: event.fetch("sws"),
            language: event.fetch("language"),
            workspace_url: event.fetch("workspace_url"),
            target_group: event.fetch("target_group"),
            description: event.fetch("name"),
            literature: event.fetch("literature"),
            remark: event.fetch("remark"),
            comments: event.fetch("comments"),
            examTopics: event.fetch("examTopics"),
            preconditions: event.fetch("preconditions"),
            contents: event.fetch("contents"),
            website: event.fetch("website"),
            short_comment: event.fetch("short_comment"),
            last_run: Time.now
          },
          description: description_hash(event).to_json
        }
        hash
      end

      def description_hash(event)
        hash = {
          "Zielgruppe" => event.fetch("target_group"),
          "Beschreibung" => event.fetch("description"),
          "Literaturhinweise" => event.fetch("literature"),
          "Bemerkung" => event.fetch("remark"),
          "Kommentar" => event.fetch("comments"),
          "Nachweis" => event.fetch("examTopics"),
          "Voraussetzungen" => event.fetch("preconditions"),
          "Lehrinhalt" => event.fetch("contents"),
          "SWS" => event.fetch("sws"),
          "Vortragssprache" => event.fetch("language"),
          "VAB" => to_link(event.fetch("workspace_url")),
          "Website" => to_link(event.fetch("website")),
          "Kurzbeschreibung" => event.fetch("short_comment")
        }
        hash.delete_if {|key, value| value.nil? }
        hash
      end

      def to_link(url)
        "<a href=\"#{url}\">#{url}</a>" if url.present?
      end

   end
end

require_relative "event_updater/event_grouper"
