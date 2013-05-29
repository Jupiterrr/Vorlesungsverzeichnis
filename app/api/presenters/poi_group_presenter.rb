class PoiGroupPresenter

  def initialize(group, embed=true)
    @group = group
    @embed = embed
  end

  def as_json(*)
    data = {
      'name' => @group.name,
      'id' => @group.id
    }
    data['pois'] = pois if @embed
    data
  end

  def pois
    @group.pois.map {|poi| PoiPresenter.new(poi, false) }
  end
  
end