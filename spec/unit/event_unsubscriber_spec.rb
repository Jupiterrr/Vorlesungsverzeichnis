# encoding: UTF-8
require "spec_helper"
require './lib/event_unsubscriber'

describe EventUnsubscriber do

  let(:user) { User.test_user }
  let(:event1) { Event.create!(name: "test event 1") }
  let(:event2) { Event.create!(name: "test event 2") }

  describe "#unsubscribe" do
    it "unsubscribes" do
      EventSubscription.create!(user_id: user.id, event_id: event1.id)
      EventUnsubscriber.unsubscribe(user, event1)
      expect(user.events.count).to eql(0)
    end
    it "saves method" do
      es = EventSubscription.create!(user_id: user.id, event_id: event1.id)
      EventUnsubscriber.unsubscribe(user, event1)
      expect(es.reload.data["delete_method"]).to eql("single")
    end
  end

  describe "#unsubscribe_all" do
    it "unsubscribes all" do
      EventSubscription.create!(user_id: user.id, event_id: event1.id)
      EventSubscription.create!(user_id: user.id, event_id: event2.id)
      EventUnsubscriber.unsubscribe_all(user)
      expect(user.events.count).to eql(0)
    end
    it "saves method" do
      es = EventSubscription.create!(user_id: user.id, event_id: event1.id)
      EventUnsubscriber.unsubscribe_all(user)
      expect(es.reload.data["delete_method"]).to eql("all")
    end
  end

end
