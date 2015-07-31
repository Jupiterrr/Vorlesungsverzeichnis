class IcalUpdateWorker
  include Sidekiq::Worker

  def perform(user_id)
    User.find(user_id).ical_file.update_ical
  end

end
