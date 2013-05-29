class PoiPresenter

  def initialize(poi, embed=true)
    @poi = poi
    @embed = embed
  end

  def as_json(*)
    data = {
      'id' => @poi.id,
      'name' => @poi.name,
      'location' => {
        'lat' => @poi.lat,
        'lng' => @poi.lng
      },
      'building_no' => @poi.building_no.to_s,
      'address' => @poi.address
    }
    data['categories'] = categories if @embed
    data
  end

  def categories
    @poi.poi_groups.map {|group| PoiGroupPresenter.new(group, false) }
  end

end