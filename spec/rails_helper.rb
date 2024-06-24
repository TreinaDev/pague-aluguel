require 'simplecov'
SimpleCov.start 'rails' do
 add_filter 'channels'
 add_filter 'mailers'
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/cuprite'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

Capybara.default_max_wait_time = 5
Capybara.disable_animation = true

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.before(:each, type: :system) do
    driven_by(:cuprite, screen_size: [1440, 810], options: {
      js_errors: false,
      headless: %w[0],
      process_timeout: 15,
      timeout: 10,
      browser_options: { "no-sandbox" => nil }
    })
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
