require 'grape-swagger'
require 'rack/cors'

class API < Grape::API

  class << self

    def api_url
      "http://#{HOST}/api"
    end

    def event_url
      "#{api_url}/events"
    end
  end

  format :json

  
  rescue_from ActiveRecord::RecordNotFound do |e|
    Rack::Response.new({message: e.message}.to_json, 404, { "Content-type" => "text/error" }).finish
  end

  rescue_from :all do |e|
    Rack::Response.new([ e.message ], 500, { "Content-type" => "text/error" }).finish
  end

  mount API_v1
  
  add_swagger_documentation base_path: API.api_url, markdown: true, hide_documentation_path: true
  
  helpers do
    # def current_user
    #   @current_user ||= User.authorize!(env)
    # end

    # def authenticate!
    #   error!('401 Unauthorized', 401) unless current_user
    # end
  end

end