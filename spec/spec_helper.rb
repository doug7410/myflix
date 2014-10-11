# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/email/rspec'
require 'sidekiq/testing'
require 'vcr'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Sidekiq::Testing.inline!  
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!


VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end

RSpec.configure do |c|
  c.fixture_path = "#{::Rails.root}/spec/fixtures"
  c.use_transactional_fixtures = false
  c.infer_base_class_for_anonymous_controllers = false
  c.order = "random"
  c.infer_spec_type_from_file_location!
  c.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  c.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  c.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  c.before(:each) do
    DatabaseCleaner.start
  end

  c.after(:each) do
    DatabaseCleaner.clean
  end

  Capybara.server_port = 52662
end
