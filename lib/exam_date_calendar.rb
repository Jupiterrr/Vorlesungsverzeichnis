class ExamDateCalendar

  def initialize(exam_dates)
    @day_groups = exam_dates.group_by {|exam_date| key(exam_date.date) }
  end

  def key(date)
    date.strftime("%d.%m.%Y")
  end

  def get_day(date)
    @day_groups.fetch(key(date), []).as_json
  end

end