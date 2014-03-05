require 'spec_helper'

describe EventSubscription do

  describe "default scope" do
    it "hides deleted" do
      user = User.test_user
      event = Event.create!(name: "test event")
      EventSubscription.create!(user_id: user.id, event_id: event.id, deleted_at: Time.now)
      expect(user.events.count).to eql(0)
    end
    it "shows everything else" do
      user = User.test_user
      event = Event.create!(name: "test event")
      EventSubscription.create!(user_id: user.id, event_id: event.id)
      expect(user.events.count).to eql(1)
    end
  end

end
