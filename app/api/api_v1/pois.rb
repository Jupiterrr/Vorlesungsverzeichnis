class API_v1::Pois < Grape::API
  resource :pois do
    

    desc "List Points Of Interest, with their categories included."
    get do
      pois = Poi.all(include: :poi_groups)
      pois.map {|poi| PoiPresenter.new(poi).as_json }
    end

    
    desc "List event categories, with the pois incuded."
    get :categories do
      groups = PoiGroup.all(include: :pois)
      groups.map {|group| PoiGroupPresenter.new(group).as_json }
    end
    
    
  end
end