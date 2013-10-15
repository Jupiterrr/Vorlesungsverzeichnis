KITBox::Application.routes.draw do

  constraints(:host => /kit.carstengriesheimer.de/) do
    root :to => redirect("http://www.kithub.de")
    match '/*path', :to => redirect {|params,request| "http://www.kithub.de/#{params[:path]}"}
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
    end
  end
  match '/timetable/:timetable_id.ics', to: 'timetable#ical', :as => :timetable_ical



  resources :events, only: [:show] do
    member do
      get 'subscribe'
      get 'unsubscribe'
      get 'dates'
      get 'edit_user_text'
      put 'update_user_text'
    end
    collection do
      get 'unsubscribe_all'
      post 'preview_md'
    end
    resources :dates, controller: "event_dates", only: [:new, :create]
  end


  resources :map, only: [:index, :show] do
    collection do
      get 'search'
      get 'list'
    end
  end


  resources :vvz, only: [:index, :show, :preload] do
    member do
      get "events/:event_id" => "vvz#events", :as => :event
      get "preload", format: "js"
    end
  end


  # skips login proccess
  if %w( development test cucumber ).include?(Rails.env.to_s)
    match "/backdoor" => "sessions#backdoor", :as => :backdoor
  end


  post "/signin" => "sessions#create", :as => :signin
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signup" => "users#new", :as => :signup


  get '/robots.txt' => 'welcomes#robots'

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'dashboard#index', :constraints => RoleConstraint.new(:user)
  root :to => redirect("/vvz")

  # See how all your routes lay out with "rake routes"
end
