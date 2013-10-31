require "spec_helper"
require "vvz_updater/vvz_updater"

describe VVZUpdater::EventDateUpdater do

  subject { VVZUpdater::EventDateUpdater.new(stub) }

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

  describe ".db_room_cach" do
    it "finds matching" do
      db1, db2 = stub("DbEDate", uuid: 1), stub("DbEDate", uuid: 2)
      date1 = stub("EDate", id: 1)
      result = subject.matches([date1], [db1, db2])
      result[0].first.should == VVZUpdater::EventDateUpdater::Match.new(date1, db1)
    end
    it "find new" do
      date1 = stub("EDate", id: 1)
      result = subject.matches([date1], [])
      result[1].first.should == VVZUpdater::EventDateUpdater::Match.new(date1, nil)
    end
  end

end
