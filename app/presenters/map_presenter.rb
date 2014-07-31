class MapPresenter

  attr_reader :poi, :pois

  COLORS = ["#4499ff", "#324189", "#730F5B", "#F52410", "#188D98", "#90B127", "#2A9C6C", "#F67710", "#3165C9"]

  ColorGroup = Struct.new(:group, :color)

  def initialize(poi_id=nil)
    @poi = poi_id && Poi.find_by_id(poi_id)
    @pois = Poi.all
  end

  def color_groups
    groups = PoiGroup.includes(:pois).all
    groups.each_with_index.map {|group, index| ColorGroup.new(group, COLORS[index]) }
  end

  def js_pois
    @pois.map {|poi| MapPoiPresenter.new(poi) }
  end

  class MapPoiPresenter < Struct.new(:poi)

    def as_json
      poi.as_json.slice("id", "name", "lat", "lng", "building_no", "address")
    end

  end

end
