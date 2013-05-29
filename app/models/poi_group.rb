class PoiGroup < ActiveRecord::Base
  has_and_belongs_to_many :pois

  def self.all_with_orphan 
    arr = self.all
    orphan_group = PoiGroup.new name: "Ohne Gruppe"
    orphan_group.pois << Poi.not_in_any_group
    arr.push orphan_group
    arr
  end

end
