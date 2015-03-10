# encoding: UTF-8
require 'upsert'
require 'upsert/active_record_upsert'
require 'pg_hstore'

module VVZUpdater
  class EventUpdater

    def initialize(term)
      @term = term
      @connection = ActiveRecord::Base.connection
    end

    def run!(events)
      grouper = EventGrouper.new(events, existing_events)
      delete(grouper.removed_db_nodes)
      # create(grouper.new_nodes)
      # update(grouper.node_pairs)
      update_events = grouper.node_pairs.map {|pair| pair.node}
      upsert_events = grouper.new_nodes + update_events
      upsert(upsert_events)
    end

    def self.run!(term, events)
      self.new(term).run!(events)
    end

    def existing_events
      Event.where(term: @term).select([:id, :external_id])
    end

    def delete(db_events)
      Event.destroy(db_events)
    end

    # def create(events)
    #   # hashes = events.map {|event| attributes_hash(event) }
    #   # Event.create(hashes)
    #   return if events.empty?
    #   hashes = events.map do |event|
    #     sql_event_value(event)
    #   end
    #   mass_insert(hashes)
    # end

    def upsert(events)
      Upsert.batch(@connection, :events) do |upsert|
        events.each do |event|
          attributes = attributes_hash(event)
          upsert.row({external_id: attributes[:external_id]}, attributes)
        end
      end
    end

    def attributes_hash(event)
      hash = {
        no: event.fetch(:nr)[4..-1],
        orginal_no: event.fetch(:nr),
        term: @term,
        _type: event.fetch(:type),
        lecturer: event.fetch(:lecturer).map {|h| h.fetch(:title) }.join(", "),
        #faculty: event.fetch(:organizer),
        external_id: event.fetch(:id),
        url: event.fetch(:url),
        original_name: event.fetch(:name),
        name: event.fetch(:name),
        data: {
          sws: event.fetch(:sws),
          language: event.fetch(:language),
          # workspace_url: event.fetch(:workspace_url),
          target_group: event.fetch(:target_group),
          description: event.fetch(:name),
          literature: event.fetch(:literature),
          remark: event.fetch(:remark),
          comments: event.fetch(:comments),
          examTopics: event.fetch(:examTopics),
          preconditions: event.fetch(:preconditions),
          contents: event.fetch(:contents),
          website: event.fetch(:website),
          short_comment: event.fetch(:short_comment),
          last_run: Time.now
        },
        description: description_hash(event).to_json
      }
      hash
    end

    def description_hash(event)
      hash = {
        # "Zielgruppe" => event.fetch("target_group"),
        "Beschreibung" => event.fetch(:description),
        "Literaturhinweise" => event.fetch(:literature),
        "Bemerkung" => event.fetch(:remark),
        "Kommentar" => event.fetch(:comments),
        "Nachweis" => event.fetch(:examTopics),
        "Voraussetzungen" => event.fetch(:preconditions),
        "Lehrinhalt" => event.fetch(:contents),
        "SWS" => event.fetch(:sws),
        "Vortragssprache" => event.fetch(:language),
        # "VAB" => to_link(event.fetch(:workspace_url)),
        "Website" => to_link(event.fetch(:website)),
        "Kurzbeschreibung" => event.fetch(:short_comment)
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
