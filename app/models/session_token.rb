class SessionToken < ActiveRecord::Base
  belongs_to :user
  validates :user, :presence => true

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.new_session!(user)
    session_token = new_token
    create!(token: digest(session_token), user_id: user.id)
    session_token
  end

  def self.find(token)
    crypt_token = digest(token)
    find_by_token(crypt_token)
  end

  # def self.find_user(token)
  #   session = Session.find(token)
  #   session.user if session
  # end

  def self.destroy(token)
    session = find(token)
    session.destroy if session
  end

end
