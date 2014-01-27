require 'rubygems'
#require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

ENV["RAILS_ENV"] = "test"

require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'capybara/poltergeist'
require "pry"
require "awesome_print"

require_relative "wait_for_ajax"

Capybara.default_selector = :css
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :poltergeist #:selenium

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, debug: false, inspector: 'launchy', js_errors: false, window_size: [1050, 768])
end

Capybara.server do |app, port|
  require 'rack/handler/thin'
  Thin::Logging.silent = true
  Rack::Handler::Thin.run(app, :Port => port)
  Rails.configuration.action_dispatch.show_exceptions = false
end

#Capybara.default_wait_time = 999999

Cucumber::Rails::Database.javascript_strategy = :truncation
DatabaseCleaner.strategy = :transaction

WebMock.disable!

Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
  # puts "driver #{Capybara.current_driver}"
  DatabaseCleaner.strategy = :truncation
end

Before do
  DatabaseCleaner.start
  # minimal seed data
  node = Vvz.create name: "KIT"
  node = node.children.create name: "term"
  node = node.children.create name: "Node1"
  node = node.children.create name: "Node2", is_leaf: true
  node.events.create name: "Schwedisch 1", _type: "type"
end



After do |s|
  # fails fast
  Cucumber.wants_to_quit = true if s.failed?
  # signout
  #visit "http://localhost:2000/signout"
  DatabaseCleaner.clean
end


# Spork.prefork do
# end

# Spork.each_run do
#   # This code will be run each time you run your specs.

#   Before('@selenium') do |scenario|
#     Capybara.current_driver = :selenium
#   end

#   After('@selenium') do |scenario|
#     Capybara.use_default_driver
#   end
# end


def screenshot(file="screenshot.png")
  page.driver.render(file)
  Launchy.open file
end


