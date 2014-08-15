class Session < ActiveRecord::Base
  belongs_to :user

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.new_session!(user)
    session_token = Session.new_token
    Session.create!(token: Session.digest(session_token), user_id: user.id)
    session_token
  end

  def self.find(token)
    return if token.nil?
    crypt_token = Session.digest(token)
    Session.find_by_token(crypt_token)
  end

  def self.find_user(token)
    session = Session.find(token)
    session.user if session
  end

  def self.destroy(token)
    session = Session.find(token)
    session.destroy if session
  end

end
