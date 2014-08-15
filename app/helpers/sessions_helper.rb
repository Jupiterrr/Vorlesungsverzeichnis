module SessionsHelper

  def sign_in(user)
    session_token = Session.new_session!(user)
    cookies.permanent["session_token"] = session_token
    self.current_user = user
  end

  def sign_out
    Session.destroy(cookies["session_token"])
    cookies.delete("session_token")
    self.current_user = nil
  end


  def current_user
    unless @current_user
      @current_user = Session.find_user(cookies["session_token"])
      # put last seen tracking code here
    end
    @current_user
  end

  def current_user=(user)
    @current_user = user
  end


  def authorize
    case User.authorize_status(current_user)
      when :signup
        redirect_to signup_path
      when :authorized
        # proceed
      else
        cookies.delete("session_token")
        redirect_to root_path, alert: "Melde dich bitte an."
    end
  end

  def authorized?(user=current_user)
    User.authorize_status(user) == :authorized
  end


end