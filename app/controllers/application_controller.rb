# encoding: UTF-8
require_dependency File.join(Rails.root, "config/features")
require_dependency "event_date_grouper"
require_dependency "ical_service"

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :prepend_view_paths
  before_filter :record_newrelic_custom_parameters

  private

  def prepend_view_paths
    prepend_view_path "app/assets/javascripts/templates/"
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

  def record_newrelic_custom_parameters
    ::NewRelic::Agent.add_custom_parameters({
        session_id: request.session_options[:id],
        user_agent: request.user_agent
    })
    ::NewRelic::Agent.add_custom_parameters({ user_id: current_user.id }) if current_user
  end

end







