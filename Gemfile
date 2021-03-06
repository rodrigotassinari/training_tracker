source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.19'
# Twitter Bootstrap
gem 'bootstrap-sass', '~> 3.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'font-awesome-sass', '~> 4.6'
gem 'font_assets', '~> 0.1'
gem 'bootstrap_form', '~> 2.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1' # TODO needed after using Turbolinks 5, why?
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.2'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.6'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma', '~> 3.6'

gem 'sucker_punch', '~> 2.0'

gem 'rollbar', '~> 2.13'

gem 'browser', '~> 2.2'

gem 'omniauth-strava', '~> 0.0'

gem 'strava-api-v3', '~> 0.6'

gem 'ar-uuid', '~> 0.1'

gem 'http_accept_language', '~> 2.0'

gem 'chronic_duration', '~> 0.10'

gem 'delocalize', '~> 1.0'

gem 'burgundy', '~> 0.2'

gem 'kaminari', '~> 0.17'

gem 'page_meta', '~> 0.1'

# markdown parser
gem 'redcarpet', '~> 3.3'

gem 'scout_apm', '~> 2.1'

group :development, :staging, :production do
  gem 'rails_12factor', '~> 0.0'
end

group :development, :test do
  gem 'rake', '~> 11.1'
  gem 'byebug', '~> 9.0'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.7'
  gem 'database_cleaner', '~> 1.5'
  gem 'rspec-collection_matchers', '~> 1.1'
  gem 'rspec-its', '~> 1.2'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'test_notifier', '~> 2.0'
end

group :test do
  gem 'fuubar', '~> 2.0'
  gem 'codeclimate-test-reporter', '~> 0.5', require: nil
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.3'

  gem 'guard-rspec', '~> 4.7', require: false

  gem 'foreman', '~> 0.82'
end
