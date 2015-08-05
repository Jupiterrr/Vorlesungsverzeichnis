# encoding: UTF-8
class SessionsController < ApplicationController

  def create
    assertion = params[:assertion] or head :bad_request
    BrowserID.verify_assertion(assertion, ENV["HOST"]) do |email, data|
      if user = User.find_by_uid(email)
        sign_in(user)
        data["redirect"] = dashboard_index_path
      else
        data["redirect"] = signup_path
        session[:uid] = email
      end
      render json: data
    end
  end

  def destroy
    sign_out
    flash[:browserID_logout] = true #params[:r] != "browserid"
    redirect_to root_url
  end

  # for cucumber testing only
  def backdoor
    sign_in(User.test_user)
    redirect_to root_url
  end

end
