# encoding: UTF-8

namespace :term do

  # Diesplays the available terms
  task :list do
    terms = KitApi::Client.new.get_terms
    names = terms.sort.map {|t| t.name }
    puts names
  end

  # task :update_local => :environment do |t, args|
  #   package_dir = "x.tar.gz"
  #   VVZUpdater.load_term(package_dir)
  # end

  # task :update_test => :environment do |t, args|
  #   url = "http://kithub.s3.amazonaws.com/terms/WS_14-15.tar.gz"
  #   Rake::Task["vvz:update"].invoke(url)
  # end

  task :update, [:term] => :environment do |t, args|
    term = args.term || abort("TERM argument missing!")
    require "vvz_updater/vvz_updater"
    VVZUpdater.update(term)
    Rake::Task["elastic:index"].invoke
  end

end

# # Some event names contain the numbers insted of
# # the actual name. This task calls the DataEnhancement
# # to fix that
# task :fix_names, [:term] => :environment do |t, args|
#   require "vvz_updater/vvz_updater"
#   VVZUpdater.improve_names(args.term)
# end

task :remove_term, [:term_id] => :environment do |t, args|
  delete_term("SS 2015")
end

def delete_term(term_name)
  Event.where(term: term_name).delete_all
  EventDate.where(term: term_name).delete_all
  term = Vvz.find_by_name(term_name)
  term.subtree.delete_all
  term.delete
end

task :remove_prefix_numbers => :environment do
  Vvz.all.each do |node|
    name = node.name
    if name =~ /^[0-9.]* /
      new_name = name.sub /^[0-9.]* /, ""
      node.update_attribute :name, new_name
    end
  end
end

task :seed_disciplines => :environment do
  open("db/disciplines.txt").read.each_line do |line|
    Discipline.find_or_create_by_name line.strip
  end
end

# require "nokogiri"
# require 'open-uri'
# class EventDateTester

#   # db_events = Event.where(term: "WS 13/14").limit(tests).order("RANDOM()")

#   def run_tests(db_events)
#     db_events.all? {|db_event| exist_all_dates?(db_event) }
#   end

#   def run_test(db_event)
#     leaf = db_event.vvzs.first
#     exist_all_dates?(db_event)
#   end

#   def exist_all_dates?(db_event)
#     db_date = get_db_dates(db_event)
#     web_dates = get_web_dates(db_event)
#     result = (web_dates - db_date).empty?
#     unless result
#       ap({
#         event_id: db_event.id,
#         url: db_event.url,
#         web_dates: web_dates,
#         db_date: db_date,
#         diff: (web_dates - db_date)
#       })
#     end
#     result
#   end

#   def get_db_dates(db_event)
#     db_event.dates.map {|d| d.start_time.to_date }
#   end

#   def get_web_dates(db_event)
#     doc = Nokogiri::HTML(open(db_event.url))
#     trs = doc.css("#appointmentlist .tablecontent > tr")
#     days = trs.each_slice(2)
#     days.flat_map do |doc_head, doc_dates|
#       day, time, room = doc_head.at_css("td:nth-child(2) a:last-child").text.split(", ")
#       if doc_dates.nil?
#         day, date_s = day.match(/(\S+) \((\S+)\)/).captures
#         dates = [Date.parse(date_s)]
#       else
#         dates = doc_dates.css("table td").map {|d| Date.parse(d.text) }
#       end
#       dates
#     end
#   end

# end


# task :test_dates => :environment do
#   db_events = Event.where(term: "WS 13/14").limit(50).order("RANDOM()")
#   ap EventDateTester.new.run_tests(db_events)
# end

# task :test_all_dates => :environment do
#   db_events = Event.where(term: "WS 13/14").limit(50).order("RANDOM()")
#   ap EventDateTester.new.run_tests(db_events)
# end

# task :update_event_and_test, [:event_id] => :environment do |t, args|
#   require "vvz_updater/vvz_updater"
#   db_event = Event.find(args[:event_id])
#   VVZUpdater.update_event(db_event)
#   ap EventDateTester.new.run_test(db_event)
# end

task :destroy_event_dates_without_source => :environment do |t, args|
  EventDate.where("data is not NULL").where("not data ? 'source'").destroy_all
end

task :go => :environment do |t, args|
  # require "vvz_updater/vvz_updater"
  # connection = KitApi::Connection.connect
  # uuid = "0x62818d1647a2644ca66d6813c28393bd"
  # event = KitApi.get_event(connection, uuid)
  # binding.pry
  # connection.disconnect
  p = Poi.where("name LIKE ?", "%gebäude%")
  binding.pry
end

task :room_to_poi => :environment do |t, args|
  require "poi_selector"
  selector = PoiSelector.new
  rooms_without_poi = Room.all #where(poi_id: nil)
  rooms_without_poi.each do |room|
    if result = selector.select(room.name)
      room.poi = result.poi
      room.data["poi.accuracy"] = result.accuracy
      room.save!
    end
  end
end

task :clear_room_pois => :environment do |t, args|
  Room.all.each do |room|
    room.poi = nil
    room.save!
  end
end

task :create_building_group => :environment do |t, args|
  group = PoiGroup.find_or_create_by_name("Gebäude")

  buildings = Poi.where("name LIKE ?", "%gebäude%")
  groups = buildings.group_by {|b| b.building_no }
  groups.map do |no, buildings|
    if buildings.count == 1
      building = buildings.first
    else
      ap buildings
      building = buildings.first
      # binding.pry # manually select correct building
    end
    [no, building]
  end
  groups.values.flatten.each do |poi|
    poi.poi_groups << group
  end

  building_nos = Poi.group(:building_no).pluck(:building_no)
  building_nos.map do |no|
    next if groups.has_key?(no)
    if positiong_poi = Poi.where(building_no: no).first
      group.pois.create building_no: no, name: "Gebäude #{no}", lat: positiong_poi.lat, lng: positiong_poi.lng
    end
  end
end



namespace :db do
  task :pull do
    db = "vvz_dev_p"
    sh "dropdb #{db}" rescue
    sh "heroku pg:pull vorlesungsverzeichnis::silver #{db}"
  end
end
# dropdb vvz_dev_p; heroku pg:pull vorlesungsverzeichnis::silver vvz_dev_p
