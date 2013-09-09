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

  task :update, [:term] => :environment do |t, args|
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

  task :new_term, [:term] => :environment do |t, args|
    require "vvz_updater/vvz_updater"
    args.term or raise "You have to pass a term!"
    VVZUpdater.updater_tree(args.term)
    VVZUpdater.link_events(args.term)
    VVZUpdater.update_events(args.term)
  end

end



# Some event names contain the numbers insted of
# the actual name. This task calls the DataEnhancement
# to fix that
task :fix_names => :environment do
  require "data_enhancement"
  DataEnhancement.improve_names
end

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

task :update_event_descriptions => :environment do
  require "fetcher/fetcher"
  hash = Fetcher.update_event_descriptions!()
  binding.pry
  File.open("tmp/edesc.dump",'w') do|file|
    Marshal::dump(hash, file)
  end
end


task :seed_disciplines => :environment do
  open("db/disciplines.txt").read.each_line do |line|
    Discipline.find_or_create_by_name line.strip
  end
end


