class API_v1 < Grape::API
  #use Garner::Middleware::Cache::Bust
  helpers Garner::Mixins::Grape::Cache

  version 'v1', :using => :header, :vendor => 'vendor'

  before { ActiveRecord::Base.logger = Logger.new(STDOUT) }

  format :json

  after do 
    header "Cache-Control", "public, max-age=2592000" unless header "Cache-Control"
  end

  mount Events
  mount Terms
  mount Pois

end