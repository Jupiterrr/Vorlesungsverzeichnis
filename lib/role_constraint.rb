class RoleConstraint
  def initialize(*roles)
    #@roles = roles
  end

  def matches?(request)
    (id = request.session[:user_id]) and (user = User.find_by_id(id)) and !user.new?
  end
end