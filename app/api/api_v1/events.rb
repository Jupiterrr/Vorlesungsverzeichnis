class API_v1::Events < Grape::API
  resource :events do

    
    desc "Get a single event"
    params do
      requires :id, :type => Integer#, :desc => "Event id."
    end
    get ':id' do
      EventPresenter.new(Event.find(params[:id])).as_json
    end


  end
end