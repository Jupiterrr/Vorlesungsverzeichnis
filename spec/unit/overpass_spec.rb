require "vcr_helper"
require './lib/overpass'

describe Overpass do
  use_vcr_cassette "Overpass", :record => :new_episodes, :match_requests_on => [:body]

  it "test" do
    geojson = Overpass.kit_area()
    File.open("./lib/kit.campus-sued.geojson", 'w') { |file| file.write(geojson.to_json) }
  end

end