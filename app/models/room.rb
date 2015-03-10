class Room < ActiveRecord::Base
  attr_accessible :name, :uuid, :poi

  belongs_to :poi
  has_many :event_dates
  validates :name, :uuid, presence: true
  validates :uuid, uniqueness: true

  before_create :try_to_find_poi

  def try_to_find_poi
    building_no = name.to_s[/\d+(\.\d+)?/]
    self.poi ||= building_no && Poi.find_by_building_no(building_no)
  end

end
