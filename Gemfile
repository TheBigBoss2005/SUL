source 'https://rubygems.org'

gem 'rails', '4.1.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'less-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Twitter Bootstrap
gem 'twitter-bootswatch-rails', '~> 3.1.1'
gem 'twitter-bootswatch-rails-helpers'

# Paginater
gem 'kaminari'
# user certification gem
gem 'devise'

# breadcrumbs
gem 'gretel'

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'rubocop'
  gem 'guard-rubocop'
  gem 'factory_girl_rails'
  gem 'childprocess'
  gem 'spring'
  gem 'guard-spring'
  gem 'spring-commands-rspec'
  gem 'database_cleaner'
  gem 'rails-erd' # er図を自動生成してくれる
end

group :test do
  gem 'capybara'
end

group :production do
  gem 'pg'
end
