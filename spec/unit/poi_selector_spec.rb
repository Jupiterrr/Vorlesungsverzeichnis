# encoding: UTF-8
require "spec_helper"
require './lib/poi_selector'

describe PoiSelector do

  let(:room_name) { "30.45 AOC 201" }

  describe ".select" do
    it "returns room" do
      room = stub
      subject.stub(:find_room) { room }
      subject.select(room_name).should == room
    end
    it "returns building" do
      building = stub
      subject.stub(:find_room) { nil }
      subject.stub(:find_building) { building }
      subject.select(room_name).should == building
    end
    it "returns nothing" do
      building = stub
      subject.stub(:find_room) { nil }
      subject.stub(:find_building) { nil }
      subject.select(room_name).should == nil
    end
  end

  # describe "--" do
  #   before do
  #     group = PoiGroup.create(name: "Gebäude")
  #     group.pois.create building_no: "10.91"
  #   end
  #   it "selects Grashof" do
  #     Poi.create! name: "Grashof", building_no: "10.91"
  #     room_name = "10.91 Grashof"
  #     ap subject.select(room_name)
  #   end
  # end

end
