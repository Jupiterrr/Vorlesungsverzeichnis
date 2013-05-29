class VvzEventPresenter

  def initialize(event, vvz)
    @event = event
    @vvz = vvz
  end

  def as_json(options={})
    event_all = EventPresenter.new(@event).as_json(no_dates: true)
    if options[:event_type] == "detail"
      event = event_all
    else
      event = event_all.slice('id', 'url')
    end
    {
      'name' => @event.name,
      'parent_id' => @vvz.id,
      'event' => event
    }
  end

end