module SessionsHelper

  def current_user
    @current_user ||= find_user
  end

  def current_user=(user)
    @current_user = user
  end

  def authorize
    unless current_user
      redirect_to root_path, alert: "Melde dich bitte an."
    end
  end

  def authorized?(user=current_user)
    user.present?
  end

  def sign_in(user)
    session_token = SessionToken.new_session!(user)
    cookies.permanent["session_token"] = session_token
    current_user = user
  end

  def sign_out
    SessionToken.destroy(cookies["session_token"])
    cookies.delete("session_token")
    current_user = nil
  end

  private
    def find_user
      if token = SessionToken.find(cookies["session_token"])
        token.user
      else
        cookies.delete("session_token")
        nil
      end
    end

end