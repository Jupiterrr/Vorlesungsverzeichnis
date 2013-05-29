# encoding: UTF-8
class SessionsController < ApplicationController
  def create
    session[:new_user_uid] = nil
    # The request has to have an assertion for us to verify
    assertion = params[:assertion] or head :bad_request
    host = request.host_with_port
    BrowserID.verify_assertion(assertion, host) do |email, data|
      user = User.sign_in(email)
      session[:user_id] = user.id
      data["redirect"] = dashboard_index_path

      render json: data
    end
  # rescue Exception => e
  #   puts "Session Exception: " << e.inspect
  #   head 500
  end
  
  def destroy
    session[:user_id] = nil
    session[:browserID_logout] = params[:r] != "browserid"
    redirect_to root_url #, :notice => "Signed out!"
  end

  # for cucumber testing only
  def backdoor
    user = User.find_by_uid(params[:email])
    session[:user_id] = user.id
    redirect_to root_url
  end

end