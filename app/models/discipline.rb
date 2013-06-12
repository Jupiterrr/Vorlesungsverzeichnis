class Discipline < ActiveRecord::Base
  attr_accessible :name, :users
  has_and_belongs_to_many :users
  has_many :exam_dates

  def to_param
    "#{id}-#{name}".parameterize
  end

end
