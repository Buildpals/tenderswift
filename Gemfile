# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'carrierwave', '~> 1.0'

gem 'cloudinary'

gem 'mime-types'

gem 'http-accept'

gem 'http-cookie'

gem 'faraday', '~> 0.14.0'

# devise for authentication
gem 'devise'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Jquery
gem 'jquery-rails'

# Use Bootstrap 4
gem 'bootstrap', '~> 4.0.0'

# FontAwesome
gem 'font-awesome-rails'

# Dropdown Select for Country
gem 'country_select'

# Entering and validating international telephone numbers
gem 'intl-tel-input-rails'

# Cocoon
gem 'cocoon'

# RailsAdmin for an easy-to-use interface for managing the apps data
gem 'rails_admin', '~> 1.2'

# Gem for handling money
gem 'money-rails', '~>1'
# Redis for ActionCable
gem 'redis', '~> 3.0'

# WYSIWYG Editor
gem 'trix'

# Authorisation
gem 'pundit'

# Step-By-Step Wizard Controllers
gem 'wicked'

gem 'geocoder'

gem 'intercom-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  # Adds support for Capybara system testing webkit, and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper'
  gem 'launchy'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'

  gem 'capybara_discoball'
  gem 'httparty'
  gem 'sinatra'

  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pundit-matchers', '~> 1.4.1'
  gem 'rspec-rails', '~> 3.7'
  gem 'shoulda-matchers', '~> 3.1'

  gem 'cucumber-rails', require: false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'

  # Code coverage
  gem 'simplecov', require: false, group: :test

  # Ruby coverage reporter for Codacy https://www.codacy.com
  gem 'codacy-coverage', require: false

  gem 'rspec_junit_formatter'

  gem 'email_spec'
  gem 'capybara-email'

  gem 'slack-notifier'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
