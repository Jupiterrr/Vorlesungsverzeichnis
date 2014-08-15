# encoding: UTF-8
class SessionsController < ApplicationController
  def create
    # The request has to have an assertion for us to verify
    assertion = params[:assertion] or head :bad_request
    host = request.host_with_port
    BrowserID.verify_assertion(assertion, host) do |email, data|
      user = User.sign_in(email)
      sign_in(user)
      data["redirect"] = dashboard_index_path
      render json: data
    end
  end

  def destroy
    sign_out
    session[:browserID_logout] = params[:r] != "browserid"
    redirect_to root_url #, :notice => "Signed out!"
  end

  # for cucumber testing only
  def backdoor
    user = User.test_user
    sign_in(user)
    redirect_to root_url
  end

end
