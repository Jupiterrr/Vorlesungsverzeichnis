source ENV['GEMFURY_URL'] if ENV['GEMFURY_URL']
source 'http://rubygems.org'
ruby '2.1.0'

gem 'rails', '~> 3.2.13'
gem 'unicorn'

gem 'kit_api', '~> 0.0.7', require: false #, path: File.join('..', 'kit_api')
gem 'celluloid', require: false

# API
gem 'grape', '~> 0.4.1'
gem 'grape-swagger', '> 0.5.0'
gem 'rack-cors'
gem 'garner', '~> 0.3.2'

# View
gem 'slim-rails'
gem 'simple_form'
gem 'high_voltage'
gem 'sitemap_generator', require: false
gem 'kaminari' # pagination
gem 'rails_autolink'
gem 'redcarpet' # markdown
gem "autoprefixer-rails"
gem 'gravtastic'

# Database
gem 'pg', '~> 0.17.1'
gem 'ancestry', '~> 2.0.0'
# gem 'redis', :require=> false
gem 'pg_search' # search
gem 'ri_cal' # timetable -> ical
gem 'activerecord-postgres-hstore'
gem "acts_as_paranoid", "~>0.4.0"
gem 'paper_trail', '>= 3.0.0.beta1' # versioning

gem 'font_assets'

# gem 'cancan' # authorization

# gem 'validates_timeliness', '~> 3.0'

group :production do
  gem 'newrelic_rpm'
  gem 'newrelic-grape'
  gem 'rails_12factor'
  gem 'intercom-rails', '~> 0.2.21'
end

group :production, :staging do
  gem 'memcachier'
  gem 'dalli', '>= 2.6.4' # memcach
  gem 'rack-cache', :require => 'rack/cache'
  # gem 'rack-contrib', :require => 'rack/contrib'
  # gem 'therubyracer'
  # gem 'less-rails', '~> 2.3.3'
  # gem 'thin'
  gem 'unicorn-worker-killer'
end

group :assets do
  gem 'sass-rails', '>= 3.1.5'
  gem 'coffee-rails', '>= 3.1.1'
  gem 'uglifier', '~> 2.5.0'
  #gem 'font-awesome-sass', '~> 4.0.0'
  gem "font-awesome-rails", '~> 4.0.0'
  gem 'hogan_assets'
end

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request', '>= 0.2.5'
  gem 'taps'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  # gem 'pry-debugger'
end

group :development, :test do
  # gem 'highline' # user input in rake task
  gem 'rspec-rails'
  gem 'zeus'
  gem 'awesome_print'
  gem 'pry-rails'
  gem 'launchy'
  gem 'thin'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem 'factory_girl_rails'
  gem 'capybara', '~> 2.0'
  gem 'poltergeist', '~> 1.5.0'

  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'spork'
  gem 'vcr'
  gem 'timecop'
  gem 'webmock', '>= 1.10'
  gem 'rspec_candy'
  # gem 'rspec-prof'
end
