require 'spec_helper'

describe Room do

  it "finds and adds Poi when created" do
    poi = Poi.create building_no: "10.10"
    room = Room.create uuid: "uuid", name: "10.10 Building"
    room.poi.should == poi
  end

end
