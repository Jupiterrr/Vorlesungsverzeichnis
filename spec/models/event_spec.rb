require 'spec_helper'

describe Event do
  
  subject { Event.create name: "Schwedisch 1" }

  describe ".track_event" do
    it "create new activity" do
      subject.track_activity "action", key: "value"
      activity = EventActivity.first
      activity.should_not be_nil
      activity.action.should eql "action"
      activity.data["key"].should eql "value"
      activity.event.should eql subject
    end
  end

end
