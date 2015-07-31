class IcalFile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content
  validates :user, :reference_key, :presence => true
  after_initialize :default_values


  def update_ical
    events = user.events.includes(:event_dates => :room)
    update_attributes(content: IcalService.ical(events))
  end

  private
    def default_values
      self.reference_key ||= SecureRandom.urlsafe_base64
    end

end
