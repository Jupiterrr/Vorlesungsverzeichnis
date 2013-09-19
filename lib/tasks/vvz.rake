# encoding: UTF-8

namespace :term do

  # Diesplays the available terms
  task :list do
    require "kit_adapter"
    # KitApi.logger.level = Logger::INFO
    connection = KitApi::Connection.connect
    terms = KitApi.get_terms(connection)
    names = terms.map {|t| t.name }
    puts names
    connection.disconnect
  end

  task :update_tree, [:term] => :environment do |t, args|
    puts "Update Term tree"
    require "vvz_updater/vvz_updater"
    #.gsub("_", " ") # Heroku doesn't like witespaces
    args.term or raise "You have to pass a term!"
    #KitApi.logger.level = Logger::DEBUG
    VVZUpdater.updater_tree(args.term)
  end

  task :link_events, [:term] => :environment do |t, args|
    puts "Links Events"
    require "vvz_updater/vvz_updater"
    #.gsub("_", " ") # Heroku doesn't like witespaces
    args.term or raise "You have to pass a term!"
    #KitApi.logger.level = Logger::WARN
    VVZUpdater.link_events(args.term)
    #binding.pry
  end

  task :update_events, [:term] => :environment do |t, args|
    puts "Update events"
    require "vvz_updater/vvz_updater"
    #.gsub("_", " ") # Heroku doesn't like witespaces
    args.term or raise "You have to pass a term!"
    #KitApi.logger.level = Logger::WARN
    VVZUpdater.update_events(args.term)
    #binding.pry
  end

  task :update, [:term] => :environment do |t, args|
    require "vvz_updater/vvz_updater"
    args.term or raise "You have to pass a term!"
    puts "Updating tree:"
    VVZUpdater.updater_tree(args.term)
    puts "Linking leafs to events:"
    VVZUpdater.link_events(args.term)
    puts "Updating events:"
    VVZUpdater.update_events(args.term)
    puts "Improve event names:"
    VVZUpdater.improve_names(args.term)
  end

end



# Some event names contain the numbers insted of
# the actual name. This task calls the DataEnhancement
# to fix that
task :fix_names, [:term] => :environment do |t, args|
  require "vvz_updater/vvz_updater"
  VVZUpdater.improve_names(args.term)
end


# depracted
task :mark_leafs => :environment do
  uni = Vvz.root
  terms = uni.children
  terms.each do |term|
    term_name = term.name
    puts term_name
    leafs = term.descendants.select {|v| v.children.empty? }
    leafs.each do |leaf|
      leaf.is_leaf = true
      leaf.save
    end
  end
end

# depracted
# When created eventes currently doesn't get the terms assigned
# so we do it afterwards with this task
task :set_term => :environment do |t, args|
  uni = Vvz.root
  terms = uni.children
  terms.each do |term|
    term_name = term.name
    puts term_name
    leafs = term.descendants.select {|v| v.children.empty? }
    leafs.each do |leaf|
      Event.update_all({:term => term_name}, {:id => leaf.events})
    end
  end
end



# Sometimes you want to delete a term.
# This task removes als nodes and events
# that belong to the term.
#
# term_id - ID of the term you want to remove
task :remove_term, [:term_id] => :environment do |t, args|
  term = Vvz.find(args[:term_id])
  Event.where(term: term.name).delete_all
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

require "nokogiri"
require 'open-uri'
class EventDateTester

  # db_events = Event.where(term: "WS 13/14").limit(tests).order("RANDOM()")

  def run_tests(db_events)
    db_events.all? {|db_event| exist_all_dates?(db_event) }
  end

  def run_test(db_event)
    leaf = db_event.vvzs.first
    exist_all_dates?(db_event)
  end

  def exist_all_dates?(db_event)
    db_date = get_db_dates(db_event)
    web_dates = get_web_dates(db_event)
    result = (web_dates - db_date).empty?
    unless result
      ap({
        event_id: db_event.id,
        url: db_event.url,
        web_dates: web_dates,
        db_date: db_date,
        diff: (web_dates - db_date)
      })
    end
    result
  end

  def get_db_dates(db_event)
    db_event.dates.map {|d| d.start_time.to_date }
  end

  def get_web_dates(db_event)
    doc = Nokogiri::HTML(open(db_event.url))
    trs = doc.css("#appointmentlist .tablecontent > tr")
    days = trs.each_slice(2)
    days.flat_map do |doc_head, doc_dates|
      day, time, room = doc_head.at_css("td:nth-child(2) a:last-child").text.split(", ")
      if doc_dates.nil?
        day, date_s = day.match(/(\S+) \((\S+)\)/).captures
        dates = [Date.parse(date_s)]
      else
        dates = doc_dates.css("table td").map {|d| Date.parse(d.text) }
      end
      dates
    end
  end

end


task :test_dates => :environment do
  db_events = Event.where(term: "WS 13/14").limit(50).order("RANDOM()")
  ap EventDateTester.new.run_tests(db_events)
end

# task :test_all_dates => :environment do
#   db_events = Event.where(term: "WS 13/14").limit(50).order("RANDOM()")
#   ap EventDateTester.new.run_tests(db_events)
# end

task :update_event_and_test, [:event_id] => :environment do |t, args|
  require "vvz_updater/vvz_updater"
  db_event = Event.find(args[:event_id])
  VVZUpdater.update_event(db_event)
  ap EventDateTester.new.run_test(db_event)
end

task :destroy_event_dates_without_source => :environment do |t, args|
  EventDate.where("data is not NULL").where("not data ? 'source'").destroy_all
end

task :go => :environment do |t, args|
  require "vvz_updater/vvz_updater"
  connection = KitApi::Connection.connect
  uuid = "0x62818d1647a2644ca66d6813c28393bd"
  event = KitApi.get_event(connection, uuid)
  binding.pry
  connection.disconnect
end






