source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass', '~> 3.3.1'
gem 'sass-rails', '>= 3.2'
gem 'autoprefixer-rails'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~>3.1.5'
gem 'bootstrap_form'
gem 'figaro'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
gem 'unicorn'
gem 'paratrooper'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe'
gem 'stripe_event'
gem 'draper', '~> 1.3'
gem 'sprockets-rails', :require => 'sprockets/railtie'

group :development do
  gem 'sqlite3'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'rspec-rails', '3.0.0'
  gem 'fabrication'
  gem 'faker'
  gem 'pry'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  gem 'childprocess'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
end

group :production do
  gem 'pg'
  gem 'sentry-raven'
  gem 'rails_12factor'
end

