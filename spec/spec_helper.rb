require 'rubygems'
require 'vcr'
require 'timeout'
require 'database_cleaner'
require 'factory_girl'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  #config.run_all_when_everything_filtered = true
  config.fail_fast = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  #config.filter_run_including :focus => true
  #c.filter_run_excluding :
  #config.filter_run :focus
  config.use_transactional_examples = false
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    FactoryGirl.lint
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { :record => :new_episodes }
end

# Spork.each_run do
#   # This code will be run each time you run your specs.
#   FactoryGirl.reload
#   require_relative "../lib/vvz_fetcher/fetcher.rb"
#   require_relative "../lib/vvz_fetcher/adapters/kit/kit_adapter.rb"
# end
