class TermEventPresenter

  def initialize(event)
    @event = event
  end

  def as_json(*)
    {
      'name' => @event.name,
      'id' => @event.id,
      'url' => "#{API.event_url}/#{@event.id}"
    }
  end

end