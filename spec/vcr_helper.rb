require 'rubygems'
require 'vcr'
require 'awesome_print'
require 'pry'

ENV["RAILS_ENV"] ||= 'test'

FOCUS = true

VCR.configure do |config|
   config.cassette_library_dir = 'spec/cassettes'
   config.hook_into :webmock
   config.configure_rspec_metadata!
   config.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |config|
   config.mock_with :rspec
   #config.use_transactional_fixtures = true
   #config.infer_base_class_for_anonymous_controllers = false
   config.run_all_when_everything_filtered = true
   config.fail_fast = true
   config.treat_symbols_as_metadata_keys_with_true_values = true
   #config.filter_run_including :focus => true
   #c.filter_run_excluding :
   config.filter_run :focus if FOCUS
   config.formatter = !FOCUS ? 'progress' : 'documentation'
   config.filter_run_excluding :long
   config.extend VCR::RSpec::Macros
   # config.around(:each) do |example|
   #   Timeout::timeout(2) {
   #     example.run
   #   }
   # end
end
