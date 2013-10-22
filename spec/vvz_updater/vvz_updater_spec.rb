require "spec_helper"
require "vvz_updater/vvz_updater"

describe VVZUpdater::EventUpdater, vcr: {match_requests_on: [:body, :uri]} do

  xit "updates" do
    event_id = "0x8e926b86147a4f499bb5b007a6c41a85"
    db_event = Event.create external_id: event_id
    connection = KitApi::Connection.connect
    event = KitApi.get_event(connection, event_id)
    updater = VVZUpdater::EventUpdater.new(db_event)
    updater.update(event)
    db_event.dates.should have(15).items
    connection.disconnect
  end

end
