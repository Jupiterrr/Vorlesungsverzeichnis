class MapController < ApplicationController

  caches_action :list, :layout => false

  def search
    result = Poi.search(params[:q]).map(&:to_search_json)
    render json: result.take(10)
  end

  def index
    @map_presenter = MapPresenter.new(params[:id])
  end

  def list
    @categories = PoiGroup.all
  end

end
