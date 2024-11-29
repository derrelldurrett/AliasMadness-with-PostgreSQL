ruby '3.2.0'

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '~> 0.10.0'
gem 'bcrypt' # Use ActiveModel has_secure_password
gem 'cancancan' # roles
gem 'coffee-rails' # Use CoffeeScript for .coffee assets and views
gem 'daemons' # Also needed for DJ
gem 'delayed_job_active_record' # Ugh at having to use DJ....
gem 'haml-rails'
gem 'jbuilder' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jquery-rails'
gem 'nokogiri' # force the following gem updates
gem 'pg'
gem 'puma' # Use Puma as the app server
gem 'rails', '~> 7.0.8'# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'record_tag_helper'
gem 'responders' # extend controller classes with respond_to
gem 'rgl' # build and traverse graphs easily
gem 'sassc-rails' # Use SCSS for stylesheets
gem 'sorted_set'
gem 'sendgrid-ruby' # mail with SendGrid
gem 'sprockets'
gem 'sprockets-rails'
gem 'turbolinks' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'uglifier' # Use Uglifier as compressor for JavaScript assets

# Use Redis adapter to run Action Cable in production
gem 'redis'

# development/test shared gems
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara' # Adds support for Capybara system testing and selenium driver
  gem 'capybara-chromedriver-logger'
  gem 'capybara-screenshot'
  gem 'cucumber-rails', require: false # 'require: false' is necessary for rake
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'libnotify' # , '0.5.9' # linux
  gem 'rb-inotify' # , '0.8.8' # linux
  gem 'rspec' # , '>= 2.14'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'selenium-devtools', '~> 0.119'
  gem 'shoulda' # , '>3.1.1'
end

group :development do
  gem 'listen' #, '>= 3.0.5', '< 3.2' # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen' #, '~> 2.0.0'
  gem 'web-console' #, '>= 3.3.0'
end

group :test do
  gem 'simplecov', require: false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'mini_racer', platforms: :ruby # See https://github.com/sstephenson/execjs#readme for more supported runtimes
end

