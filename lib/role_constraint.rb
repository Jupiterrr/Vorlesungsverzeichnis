class RoleConstraint
  # include SessionsHelper
  # attr_accessor :cookies

  def initialize(*roles)
    #@roles = roles
  end

  def matches?(request)
    request.cookies.key?("session_token")
  end
end
