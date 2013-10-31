require "spec_helper"
require "vvz_updater/vvz_updater"

describe VVZUpdater::EventUpdater, vcr: {match_requests_on: [:body, :uri]} do

  describe ".update_event" do
    it "updates correctly" do
      db_event = Event.create! external_id: "0xaefda07be09a7c43875d5ce13378a1cc"
      updater = VVZUpdater.update_event(db_event, false)
      db_event.dates.should have(23).items
      db_event.dates.map(&:room_id).flatten.should have(23).items
    end
  end

end
