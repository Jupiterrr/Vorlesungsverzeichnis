require "spec_helper"
require "vvz_updater/vvz_updater"

describe VVZUpdater::EventDateUpdater do

  subject { VVZUpdater::EventDateUpdater.new(stub) }

  context "example" do
    before do
      @db_event = Event.create!
      @db_event.dates.create([{
        uuid: "existing",
        start_time: nil
      }, {
        uuid: "remove"
      }])
      @dates = [
        stub("Date", id: "existing", room: nil, start: Time.now).as_null_object,
        stub("Date", id: "new", room: nil).as_null_object
      ]
    end
    it "does" do
      subject.update(@db_event, @dates)
      db_dates = @db_event.dates
      expect(db_dates.exists?(uuid: "remove")).to be false
      expect(db_dates.exists?(uuid: "new")).to be true
      expect(db_dates.exists?(uuid: "existing")).to be true
      existing = db_dates.find_by_uuid("existing")
      expect(existing.start_time.nil?).to be false
    end
  end

  describe ".db_room_cach" do
    it "calls only once" do
      room = stub
      subject.should_receive(:find_or_create_room).once
      subject.db_room_cach[room]
      subject.db_room_cach[room]
    end
    it "finds correct" do
      room, db_room = stub, stub
      subject.should_receive(:find_or_create_room) { db_room }.with(room).once
      subject.db_room_cach[room].should == db_room
    end
  end

end
