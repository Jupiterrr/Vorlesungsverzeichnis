source 'http://rubygems.org'
ruby '1.9.3'

gem 'rails', '~> 3.2.13'
gem 'unicorn'

gem 'awesome_print'
gem 'pry'

# API
gem 'grape', '>= 0.4.1'
gem 'grape-swagger', '>= 0.5.0'
gem 'rack-cors'
gem 'garner', '>= 0.3.2'

# View
gem 'slim-rails'
gem 'simple_form'
gem 'high_voltage'
gem 'simple_calendar', '~> 0.1.8'
gem 'sitemap_generator'
gem 'kaminari' # pagination
gem 'rails_autolink'

# Database
gem 'pg'
gem 'ancestry', '~> 2.0.0'
# gem 'redis', :require=> false
gem 'pg_search' # search
gem 'ri_cal' # timetable -> ical
gem 'activerecord-postgres-hstore'
gem "acts_as_paranoid", "~>0.4.0"

# gem 'cancan' # authorization
gem 'rspec_candy'

gem 'validates_timeliness', '~> 3.0'

group :production do
  gem 'newrelic_rpm'
  gem 'newrelic-grape'
end

group :production, :staging do
  gem 'memcachier'
  gem 'dalli', '>= 2.6.4' # memcach
  gem 'rack-cache', :require => 'rack/cache'
  # gem 'rack-contrib', :require => 'rack/contrib'
  gem 'therubyracer'
  gem 'less-rails', '~> 2.3.3'
  gem 'thin'
end

group :assets do
  gem 'sass-rails', '>= 3.1.5'
  gem 'coffee-rails', '>= 3.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'hogan_assets'
end

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request', '>= 0.2.5'
  gem 'taps'
end

group :development, :test do
  # gem 'highline' # user input in rake task
  gem 'rspec-rails'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem 'factory_girl_rails'
  gem 'capybara', '~> 2.0'
  gem 'poltergeist', '~> 1.1'

  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'spork'
  gem 'vcr'
  gem 'timecop'
  gem 'webmock', '>= 1.10'

  # gem 'rspec-prof'
end
