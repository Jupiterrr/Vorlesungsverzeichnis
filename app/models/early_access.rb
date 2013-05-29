class EarlyAccess < ActiveRecord::Base
  attr_accessible :mail

  def self.allowed?(mail)
    exists?(mail: mail)
  end

  def self.add(mail)
    create mail: mail
  end

  def self.remove(mail)
    EarlyAccess.delete_all mail: mail
  end

  def self.all_mails
    pluck(:mail)
  end

end
