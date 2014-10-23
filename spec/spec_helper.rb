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
Capybara.server_port = 52662

Capybara.register_driver :poltergeist do |app|
  options = {
  :js_errors => false,
  :timeout => 120,
  :debug => false,
  :phantomjs_options => ['--load-images=no', '--disk-cache=false', '--ignore-ssl-errors=yes'],
  :inspector => true
  }
Capybara::Poltergeist::Driver.new(app, options)
end
 
Capybara.default_wait_time = 5


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
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
