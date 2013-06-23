require 'net/http'
require 'json'
# encoding: UTF-8
class Overpass

  API_URL = 'http://www.overpass-api.de/api/interpreter?data=[timeout:1][out:json];'
  WAY_ID = 134631687

  def self.kit_area()
    #query = 'way[amenity=university](49.007305486084334,8.403854370117188,49.019971765823975,8.42702865600586);out+body;>;out+skel;'
    query = '(way(134631687);>;);out skel;'
    uri = API_URL << query
    res = Net::HTTP.get_response(URI(URI.escape(uri)))
    if res.is_a?(Net::HTTPSuccess)
      result = res.body
      elements = JSON.parse(result)["elements"]
      id_map = elements.map {|x| [x["id"], x]}
      id_map = Hash[id_map]

      way = id_map[WAY_ID]
      way["nodes"] = way["nodes"].map {|n| id_map[n]}
      to_geojson(way)
    end
  end

  def self.to_geojson(way)
    {
      "type"=> "Feature",
      "geometry"=> {
        "type"=> "Polygon",
        "coordinates"=> [way["nodes"].map {|node| [node["lon"], node["lat"]] }]
      },
      "properties"=> {
        "@type"=> "way",
        "@id"=> way["id"],
        "name"=> "Campus Sued"
      }
    }
  end

end
