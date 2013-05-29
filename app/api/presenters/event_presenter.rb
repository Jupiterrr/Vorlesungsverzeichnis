class EventPresenter

  def initialize(event)
    @event = event
  end

  def as_json(options={})
    data = {
      'id' => @event.id,
      'no' => @event.nr,
      'name' => @event.name,
      'type' => @event.simple_type,
      'lecturer' => @event.lecturer,
      'official_url' => @event.url,
      'description' => @event.description,
      'url' => "#{API.event_url}/#{@event.id}"
    }
    data['dates'] = dates unless options[:no_dates]
    data
  end

  def dates
    @event.dates.map do |date|
      DatePresenter.new(date).as_json
    end
  end
end
