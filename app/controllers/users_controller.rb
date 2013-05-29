class UsersController < ApplicationController

  before_filter :require_user

  def new
    @user = current_user
    update if params[:user]
  end

  private 

  def update
    if @user.update_attributes params[:user].slice(:name, :discipline_ids)
      session[:user_id] = @user.id
      redirect_to dashboard_index_path
    end
  end

  def require_user
    redirect_to vvz_index_path unless current_user
  end

end
