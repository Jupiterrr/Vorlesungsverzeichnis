# encoding: UTF-8

class PoiSelector

  def building_group
    @building_group ||= PoiGroup.find_by_name("Gebäude")
  end

  def select(room_name)
    room_query = get_room_query(room_name)
    find_room(room_query) || find_building(room_query)
  rescue UnsupportedName
    nil
  end

  def get_room_query(room_name)
    building_no, name = room_name.split(' ', 2)
    raise UnsupportedName unless building_no && name
    RoomQuery.new(building_no, name)
  rescue UnsupportedName
    puts "WARNING: Format of '#{room_name}' is not supported"
    raise
  end

  def find_room(room_query)
    name_part = room_query.name.split(" ").first
    return if name_part.length < 4
    base_query = Poi.where(building_no: room_query.building_no)
    fine_query = base_query.where("name LIKE ?", "%#{name_part}%")
    poi = fine_query.first
    poi && SelectResult.new(poi, ".find_room")
  end

  def find_building(room_query)
    base_query = building_group.pois.where(building_no: room_query.building_no)
    poi = base_query.first
    poi && SelectResult.new(poi, ".find_building")
  end

  class UnsupportedName < ArgumentError; end
  RoomQuery = Struct.new(:building_no, :name)
  SelectResult = Struct.new(:poi, :accuracy)

end
