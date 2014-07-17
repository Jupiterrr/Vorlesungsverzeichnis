# encoding: UTF-8
require_dependency "feature_flipper"
require_dependency "event_date_grouper"

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :prepend_view_paths
  before_filter :record_newrelic_custom_parameters

  private

  def prepend_view_paths
    prepend_view_path "app/assets/javascripts/templates/"
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def authorize
    if current_user
      case current_user.authorize_status
      when :signup
        redirect_to signup_path
      when :ok
      end
    else
      redirect_to root_path, alert: "Melde dich bitte an."
    end
  end

  def authorized?
    current_user && !current_user.new?
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default
    redirect_to(session[:return_to] || root_url)
    session[:return_to] = nil
  end

  delegate :feature, :to => :Features
  helper_method :feature

  helper_method :current_user, :authorized?, :authorize

  def record_newrelic_custom_parameters
    if current_user
      ::NewRelic::Agent.add_custom_parameters({ user_id: current_user.id })
    end
    true
  end

end







