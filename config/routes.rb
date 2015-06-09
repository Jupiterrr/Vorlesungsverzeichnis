require "role_constraint"
KITBox::Application.routes.draw do

  constraints(:host => /kit.carstengriesheimer.de|\w*.herokuapp.com/) do
    root :to => redirect("https://www.kithub.de")
    match '/*path', :to => redirect {|params,request| "https://www.kithub.de/#{params[:path]}"}
   end

  resources :disciplines, only: [:index, :show] do
    resources :exam_dates do
      get 'delete', on: :member
    end
  end


  mount API => '/api'

  resources :dashboard, only: :index
  resources :documents, only: :new
  resources :search, only: :index
  resources :users, only: [:new]


  resources :timetable, only: :index do
    collection do
      get 'regenerate'
      get 'exam'
      get 'print'
      get 'print_service'
    end
  end
  match '/timetable/:timetable_id.ics', to: 'timetable#ical', :as => :timetable_ical

  class PostFeatureConstraint
    def self.matches?(request)
      request.format == :html && allowed?(request)
    end
    def self.allowed?(request)
      id = request.session[:user_id] or return
      user = User.find_by_id(id) or return
      event = Event.find(request.params[:id]) or return
      user.data["post_feature_flip"] == "true" && event.subscribed?(user)
    end
  end

resources :events, only: [] do
    collection do
      get 'unsubscribe_all'
      post 'preview_md'
    end

    member do
      get 'subscribe'
      get 'unsubscribe'
      get 'dates'
      get 'info'
      get 'edit_user_text'
      put 'update_user_text'
    end

    resources :dates, controller: "event_dates", only: [:new, :create]
  end
  get "events/:id" => 'events#show', :constraints => PostFeatureConstraint
  get "events/:id" => 'events#info', :constraints => {:format => /html/}
  get "events/:id" => 'events#show', :constraints => {:format => /js|json/}, :as => :event

  resources :map, only: [:index] do
    collection do
      get 'search'
      get 'list'
    end
  end
  get "/map/:id" => "map#index", :as => :map


  resources :vvz, only: [:index, :show, :preload] do
    member do
      get "events/:event_id" => "vvz#events", :as => :event

    end
    collection do
      get "preload", :constraints => {:format => /js|json/}
    end
  end

  resources :posts, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  # skips login proccess
  if %w( development test cucumber ).include?(Rails.env.to_s)
    match "/backdoor" => "sessions#backdoor", :as => :backdoor
  end

  post "/signin" => "sessions#create", :as => :signin
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signup" => "users#new", :as => :signup
  match "/auth/:provider/callback" => "sessions#saml"

  get '/robots.txt' => 'welcomes#robots'

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'dashboard#index', :constraints => RoleConstraint.new(:user)
  root :to => 'welcomes#index'

  # See how all your routes lay out with "rake routes"
end
