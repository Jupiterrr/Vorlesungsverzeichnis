class ExamDate < ActiveRecord::Base
  belongs_to :event
  belongs_to :discipline
  attr_accessible :data, :date, :name, :type, :discipline_id, :text

  validates_date :date

  serialize :data, ActiveRecord::Coders::Hstore
  include Rails.application.routes.url_helpers

  self.inheritance_column = nil

  def start_time
    date
  end

  def text
    data["text"]
  end

  def text=(text)
    data["text"] = text
  end

  def rails_path
    discipline_exam_date_path(discipline, self)
  end

  def as_json
    attributes.slice("name", "date").merge("url" => rails_path)
  end

end
