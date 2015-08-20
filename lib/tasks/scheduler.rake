# require "kit_api"
# require 'yo-ruby'
# Yo.api_key = ENV["YO_KEY"]

namespace :cron do
  task :check_new_term => :environment do
    # abort "already checked" if Store[:new_term_ss15]
    # terms = KitApi::Client.new.get_terms.map(&:name)
    # if terms.include?("SS 2015")
    #   puts "New VVZ!"
    #   Yo.yo!("JUPITERRR")
    #   Store[:new_term_ss15] = Time.now
    # else
    #   puts ":("
    # end
  end

  task :update_vvz => :environment do
    VvzWorker.update_async(Vvz.find_by_name!("WS 2013").id)
  end
end
