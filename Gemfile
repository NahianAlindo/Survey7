source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
gem 'sass-rails', '~> 5.0'
# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'translate_enum', '~> 0.1.3'
gem 'uglifier', '>= 1.3.0'
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
gem 'coffee-rails', '~> 4.2'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 1.0"
gem "slim-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
gem 'activerecord-import'
gem 'activerecord-session_store'
gem 'active_storage_validations'
gem 'amoeba'
# gem 'audited', '~> 4.9'
gem 'audited_async'
gem 'aws-sdk-s3', require: false
gem 'bootstrap-datepicker-rails'
gem 'breadcrumbs_on_rails'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'clockpicker-rails'
gem 'date_validator'
gem 'devise'
gem 'dotenv-rails'
gem 'geokit-rails', '2.3.2'
gem 'gon'
gem 'grape', '1.5.3' # for creating API
gem 'grape-active_model_serializers', '1.5.2'
gem 'httparty'
gem 'image_processing'
gem 'jwt', '2.2.2'
gem 'mini_magick', '>= 4.9.5'
gem 'photoswipe-rails'
gem 'rack-cors', '1.1.1' # for modifying rack req on the flow
gem 'rails_autolink', '~> 1.1', '>= 1.1.6'
gem 'rails_sortable'
gem 'redis-namespace'
gem 'redis-rails'
gem 'render_async'
gem 'rest-client'
gem "roo", "~> 2.8.0"
gem 'roo-xls'
gem 'simple_form'
gem 'slim'
gem 'tinymce-rails'
gem 'whenever', require: false
gem 'will_paginate', '~> 3.1.0'
gem 'email_address'
gem "breadcrumbs_on_rails"
gem "font-awesome-sass", "~> 6.3.0"
# Gem for finding string similarity
gem 'fuzzy_match', '~> 2.1'
gem 'similar_strings', '~> 0.0.1'

# Job queue
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 3.0', '>= 3.0.1'
gem 'sinatra', require: false
# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'bullet'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'letter_opener'

  gem 'therubyracer'
  gem 'execjs'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
