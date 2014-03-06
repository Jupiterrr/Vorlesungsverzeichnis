# encoding: UTF-8
module VVZUpdater
   class EventUpdater

      def initialize(db_event)
        @db_event = db_event
        @date_updater = EventDateUpdater.new(:event_updater)
      end

      def update(event)
        attributes = attributes_hash(event)
        status = @db_event.update_attributes(attributes)
        @date_updater.update(@db_event, event.dates)
      end

      def attributes_hash(event)
        hash = {
          no: event.nr[4..-1],
          orginal_no: event.nr,
          term: event.term,
          _type: event.type,
          lecturer: event.lecturer.map(&:title).join(", "),
          #faculty: event.organizer,
          url: event.url,
          original_name: event.name,
          data: {
            sws: event.sws,
            language: event.language,
            workspace_url: event.workspace_url,
            target_group: event.target_group,
            description: event.name,
            literature: event.literature,
            remark: event.remark,
            comments: event.comments,
            examTopics: event.examTopics,
            preconditions: event.preconditions,
            contents: event.contents,
            website: event.website,
            short_comment: event.short_comment,
            last_run: Time.now
          },
          description: description_hash(event).to_json
        }
        hash[:name] = event.name if @db_event.name.nil?
        hash
      end

      def description_hash(event)
        hash = {
          "Zielgruppe" => event.target_group,
          "Beschreibung" => event.description,
          "Literaturhinweise" => event.literature,
          "Bemerkung" => event.remark,
          "Kommentar" => event.comments,
          "Nachweis" => event.examTopics,
          "Voraussetzungen" => event.preconditions,
          "Lehrinhalt" => event.contents,
          "SWS" => event.sws,
          "Vortragssprache" => event.language,
          "VAB" => to_link(event.workspace_url),
          "Website" => to_link(event.website),
          "Kurzbeschreibung" => event.short_comment
        }
        hash.delete_if {|key, value| value.nil? }
        hash
      end

      def to_link(url)
        "<a href=\"#{url}\">#{url}</a>" if url.present?
      end

   end
end
