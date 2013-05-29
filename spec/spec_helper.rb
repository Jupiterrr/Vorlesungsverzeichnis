require 'rubygems'
require 'spork'
require 'vcr'
require 'timeout'

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
end

def json_fixture(filename)
    tree = file_fixture("#{filename}.json")
    tree = JSON.parse(tree)
    tree = to_sym_keys(tree)
end

def to_sym_keys(obj)
  return obj unless obj.respond_to?(:each)
  return obj.map {|x| to_sym_keys(x) } if obj.is_a?(Array)
  
  hash = {}
  obj.each do |key, value|
    hash[key.to_sym] = to_sym_keys(value)
  end
  hash
end

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
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
    #config.extend VCR::RSpec::Macros
    # config.around(:each) do |example|
    #   Timeout::timeout(2) {
    #     example.run
    #   }
    # end
  end
  
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/cassettes'
    config.hook_into :webmock
    config.configure_rspec_metadata!
    config.default_cassette_options = { :record => :new_episodes }
  end

end


# Spork.each_run do
#   # This code will be run each time you run your specs.
#   FactoryGirl.reload
#   require_relative "../lib/vvz_fetcher/fetcher.rb"
#   require_relative "../lib/vvz_fetcher/adapters/kit/kit_adapter.rb"
# end
