# encoding: UTF-8
require 'pry-remote'
module VVZUpdater
   class EventUpdater

      def initialize(db_event)
        @db_event = db_event
        @date_updater = EventDateUpdater.new(:event_updater)
      end

      def update(event)
        attributes = event.attributes
        status = @db_event.update_attributes({
          nr: attributes.fetch(:nr),
          term: attributes.fetch(:term),
          name: attributes.fetch(:name),
          _type: attributes.fetch(:type),
          lecturer: attributes.fetch(:lecturer).map(&:title).join(", "),
          #faculty: attributes.fetch(:organizer),
          url: attributes.fetch(:url),
          original_name: attributes.fetch(:name),
          data: {
            sws: attributes.fetch(:sws),
            language: attributes.fetch(:language),
            workspace_url: attributes.fetch(:workspace_url),
            target_group: attributes.fetch(:target_group),
            description: attributes.fetch(:name),
            literature: attributes.fetch(:literature),
            remark: attributes.fetch(:remark),
            comments: attributes.fetch(:comments),
            examTopics: attributes.fetch(:examTopics),
            preconditions: attributes.fetch(:preconditions),
            contents: attributes.fetch(:contents),
            website: attributes.fetch(:website),
            short_comment: attributes.fetch(:short_comment),
            last_run: Time.now
          },
          description: description_hash(event).to_json
        })
        @date_updater.update(@db_event, event.dates)
      end

      def description_hash(event)
        attributes = event.attributes
        hash = {
          "Zielgruppe" => attributes.fetch(:target_group),
          "Beschreibung" => attributes.fetch(:description),
          "Literaturhinweise" => attributes.fetch(:literature),
          "Bemerkung" => attributes.fetch(:remark),
          "Kommentar" => attributes.fetch(:comments),
          "Nachweis" => attributes.fetch(:examTopics),
          "Voraussetzungen" => attributes.fetch(:preconditions),
          "Lehrinhalt" => attributes.fetch(:contents),
          "SWS" => attributes.fetch(:sws),
          "Vortragssprache" => attributes.fetch(:language),
          "VAB" => to_link(attributes.fetch(:workspace_url)),
          "Website" => to_link(attributes.fetch(:website)),
          "Kurzbeschreibung" => attributes.fetch(:short_comment)
        }
        hash.delete_if {|key, value| value.nil? }
        hash
      end

      def to_link(url)
        "<a href=\"#{url}\">#{url}</a>" if url.present?
      end

   end
end
