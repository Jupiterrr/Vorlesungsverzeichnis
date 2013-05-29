class DatePresenter

  def initialize(date)
    @date = date
  end

  def as_json(*)
    {
      'start_time' => @date.start_time,
      'end_time' => @date.end_time,
      'room' => @date.room
    }
  end

end
