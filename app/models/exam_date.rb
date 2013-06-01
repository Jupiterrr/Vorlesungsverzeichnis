class ExamDate < ActiveRecord::Base
  belongs_to :event
  belongs_to :discipline
  attr_accessible :data, :date, :name, :type, :discipline_id
  self.inheritance_column = nil


end
