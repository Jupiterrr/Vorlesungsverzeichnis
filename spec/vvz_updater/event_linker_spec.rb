require "spec_helper"

require "vvz_updater/vvz_updater"

describe VVZUpdater::EventLinker, vcr: {match_requests_on: [:body]} do

  # leaf_id = "0xc122e9d3016ee84795aa41aa7663e9de"
  let(:db_event) { Event.create }
  subject { EventLinker.new(db_event) }

  it "update_dates" do
    event = stub("Event", dates: )
    subject.update_dates(db_event, event)

  end

end
