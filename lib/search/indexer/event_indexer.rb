class KithubIndexer
  class EventIndexer
    include IndexHelper

    def index!(client)
      Event.includes(:vvzs).find_in_batches(batch_size: 500) do |events|
        client.bulk(body: event_ops(events))
      end
    end

    def event_ops(events)
      ops = events.map do |event|
        if event.vvzs.exists?
          data = event_data(event)
          index_hash(:event, event.id, data)
        end
      end.compact
    end

    def event_data(event)
      {name: event.name, term: event.term, course_id: event.no, description: event.description, lecturer: event.lecturer, event_type: event.simple_type, url: vvz_event_url(event)}
    end

    def vvz_event_url(event)
      vvz_id = event.vvz_ids.first
      "/vvz/#{vvz_id}/events/#{event.id}"
    end

  end
end
