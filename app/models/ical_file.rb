class IcalFile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content
  validates :user, :reference_key, :presence => true
  after_initialize :default_values

  def self.find_with_key(key)
    find_by_reference_key(key) || find_via_user(key) || (raise ActiveRecord::RecordNotFound, "Couldn't find #{self.to_s} with key=#{key}")
  end

  def update_ical
    events = user.events.includes(:event_dates => :room)
    update_attributes(content: IcalService.ical(events))
  end

  private
    def default_values
      self.reference_key ||= SecureRandom.urlsafe_base64
    end

    def self.find_via_user(key)
      user = User.find_by_timetable_id(key)
      user.ical_file if user
    end

end
