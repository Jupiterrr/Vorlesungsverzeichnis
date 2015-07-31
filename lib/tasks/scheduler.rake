# require "kit_api"
# require 'yo-ruby'
# Yo.api_key = "c0c05da1-56bf-f17a-6d69-d71dab7e28b8"

# task :check_new_term => :environment do
#   abort "already checked" if Store[:new_term_ss15]
#   terms = KitApi::Client.new.get_terms.map(&:name)
#   if terms.include?("SS 2015")
#     puts "New VVZ!"
#     Yo.yo!("JUPITERRR")
#     Store[:new_term_ss15] = Time.now
#   else
#     puts ":("
#   end
# end
