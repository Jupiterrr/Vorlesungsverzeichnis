# encoding: UTF-8

# Tip:
# Rake tasks often require to run with bundle exec
# Be safe and run everything depending rails with bundle exec.
#
# $ bundle exec rake kit:load[SS_2013]
#

namespace :kit do

  # Diesplays the available terms
  task :terms do
    require "kit_adapter/kit_adapter"
    puts KitAdapter.new.get_terms.map {|t| t.name }
  end

  # Download a term and saves it to tmp/
  #
  # term - Name of the term. e.g. "SS_2013"
  task :download, :term do |t, args|
    # "WS 12/13"
    args[:term].gsub!("_", " ") # Heroku doesn't like witespaces
    require "kit_adapter/kit_adapter"
    termdump = KitAdapter.new.get_vvz(args[:term])
    termdump.save
  end

  # Loads a term dump and creates nodes, events and dates.
  #
  # term - Name of the term. e.g. "SS_2013"
  task :load, [:term] => :environment do |t, args|
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    require "fetcher/fetcher"
    args[:term].gsub!("_", " ") # Heroku doesn't like witespaces
    term_dump = Fetcher::Adapter::TermDump.load("KIT", args[:term])
    #Fetcher.update_term(term_dump)
    Fetcher.update!(term_dump)
    Rake::Task['fix_names'].invoke
    Rake::Task['set_term'].invoke
  end

  # Loads a term dump and creates nodes, events and dates.
  #
  # term - Name of the term. e.g. "SS_2013"
  task :update_events, [:term] => :environment do |t, args|
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    require "fetcher/fetcher"
    args[:term].gsub!("_", " ") # Heroku doesn't like witespaces
    term_dump = Fetcher::Adapter::TermDump.load("KIT", args[:term])
    #Fetcher.update_term(term_dump)
    Fetcher.update_events!(term_dump)
    Rake::Task['fix_names'].invoke
    Rake::Task['set_term'].invoke
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


task :save_eventdesc => :environment do 
  a = []
  Event.all.each do |event|
    a << event.external_id
    a << event.read_attribute(:description)
  end
  hash = Hash[*a]
  File.open("tmp/edesc.dump",'w') do|file|
    Marshal::dump(hash, file)
  end
end

task :load_eventdesc => :environment do 
  hash = File.open("tmp/edesc.dump",'r') do|file|
    Marshal.load(file)
  end
  hash.each do |key, val|
    if event = Event.find_by_external_id(key)
      event.update_attribute :description, val
    end
  end
end

task :seed_disciplines => :environment do
  open("db/disciplines.txt").read.each_line do |line|
    Discipline.find_or_create_by_name line.strip
  end
end

# ActiveRecord::Base.establish_connection
# ActiveRecord::Base.connection.execute('DELETE FROM "events_vvzs"')
