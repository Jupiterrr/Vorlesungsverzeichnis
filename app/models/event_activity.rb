class EventActivity < ActiveRecord::Base
  belongs_to :event
  attr_accessible :action
  serialize :data, ActiveRecord::Coders::Hstore

  scope :user_feed, lambda { |user| 
    where(event_id: user.event_ids) 
  }

end
