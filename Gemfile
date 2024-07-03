source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'
gem 'rails', '~> 7.1.3.1'

gem 'bootsnap', require: false
gem 'cpf_cnpj'
gem 'cssbundling-rails'
gem 'devise'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'money-rails', '~> 1.12'
gem 'puma', '~> 6.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'sqlite3', '~> 1.4'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'byebug'
  gem 'cuprite'
  gem 'debug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'simplecov', require: false
end

# Use Redis for Action Cable
gem "redis", "~> 4.0"
