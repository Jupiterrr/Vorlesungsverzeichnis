class Poi < ActiveRecord::Base
  has_and_belongs_to_many :poi_groups
  has_many :rooms

  def self.search(query)
    query = "%" + query.downcase + "%"
    where("lower(name) LIKE ? OR building_no LIKE ?", query, query)
  end

  def to_json
    attributes.except("created_at", "updated_at")
  end

  def to_search_json
    #attributes.slice("id", "lat", "lng", "name")
    attributes.except("created_at", "updated_at")
  end

  scope :not_in_any_group, {
    :joins      => "LEFT JOIN poi_groups_pois ON pois.id = poi_groups_pois.poi_id",
    :conditions => "poi_groups_pois.poi_id IS NULL",
    :select     => "DISTINCT pois.*"
  }

end
