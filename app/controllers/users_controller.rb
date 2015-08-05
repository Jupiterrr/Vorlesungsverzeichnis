class UsersController < ApplicationController

  before_filter :require_user

  def new
    @user = User.new uid: session[:new_uid]
  end

  def create
    @user = User.new params[:user].slice(:name, :discipline_ids)
    @user.uid = session[:uid]
    @user.data = {} # hack
    if @user.save
      sign_in(@user)
      redirect_to dashboard_index_path
    else
      render action: "new"
    end
  end

  private

  def require_user
    redirect_to vvz_index_path unless session[:uid]
  end

end
