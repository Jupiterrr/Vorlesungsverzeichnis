class MapController < ApplicationController

  caches_action :index, :show, :list, :layout => false
  caches_page :search

  def search
    result = Poi.search(params[:q]).map(&:to_search_json)
    render json: result.take(10)
  end

  def index
    colors = ["#4499ff", "#324189", "#730F5B", "#F52410", "#188D98", "#90B127", "#3165C9", "#2A9C6C", "#F67710"]
    @pois = Poi.all(:include => :poi_groups)
    @poi = Poi.find_by_id(params[:id])
    
    @js_pois = @pois.map do |poi| 
      data = poi.as_json.slice("id", "name", "lat", "lng", "building_no", "address")
      data["poi_group_ids"] = poi.poi_group_ids
      data
    end
    @groups_with_orphan = PoiGroup.all_with_orphan
    @colors = {}
    @groups_with_orphan.each {|group| @colors[group] = colors.pop }
    @groups = PoiGroup.all
  end

  def list
    @categories = PoiGroup.all
  end

  def show
    index
    render :index
  end

end
