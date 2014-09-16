require "spec_helper"
require "vvz_updater/vvz_updater"

FIXTURE_DIR = File.join(Dir.pwd, "spec", "vvz_updater", "fixtures")

def untar()
  VVZUpdater.untar("spec/vvz_updater/SS 2006-json.tar.gz", FIXTURE_DIR)
end

describe VVZUpdater::EventUpdater, vcr: {match_requests_on: [:body, :uri]} do

  let(:term) { "SS 2010" }
  subject { VVZUpdater::EventUpdater.new(term) }

  # describe ".update_event", no_ci: true do
  #   it "updates correctly" do
  #     db_event = Event.create! external_id: "0xaefda07be09a7c43875d5ce13378a1cc"
  #     updater = VVZUpdater.update_event(db_event, false)
  #     db_event.dates.should have(23).items
  #     db_event.dates.map(&:room_id).flatten.should have(23).items
  #   end
  # end

  it ".existing_events" do

  end

end
