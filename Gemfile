source 'https://rubygems.org'

# MongoDB gems
gem 'mongoid'
gem 'bson_ext'

# Style gems and helpers
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'sprockets-rails'
gem 'font-awesome-rails'
gem 'icheck-rails'

# Authentication and Authorization
gem 'devise'
gem 'cancancan'

# Pagination
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem "breadcrumbs_on_rails"

# Simple form
gem 'simple_form'
gem 'nested_form'
gem 'best_in_place'

# Enumerize fields
gem 'enumerize'

# Displays chart
gem 'chartkick'
gem 'groupdate'

# UTF-8 cleaner
gem 'utf8-cleaner'

gem 'language_list'

# analytics
gem 'ahoy_matey'

# Generate fake data
gem 'faker'

# calendar
gem "simple_calendar"

# datetimepicker and country select
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'country_select'
gem 'momentjs-rails'

# file uload
gem "jquery-fileupload-rails"
gem 'ckeditor', '4.1.1'
gem "mongoid-paperclip", :require => "mongoid_paperclip"

gem 'underscore-rails'

# Datatables
gem 'jquery-datatables-rails'
gem 'mongoid_datatable', path:'vendor/gems/mongoid_datatable'

# Internalization
gem 'rails-i18n'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.0.4'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :production do
  gem 'unicorn'
  gem 'pg'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  gem "rubycritic", :require => false

  # A Ruby static code analyzer, based on the community Ruby style guide.
  gem 'rubocop', require: false

  # static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  gem 'brakeman'

  # find dead routes and unused actions
  gem 'traceroute'

  # irb console
  gem "better_errors"
  gem "binding_of_caller"

  #rails_best_practices is a code metric tool to check the quality of Rails code.
  gem "rails_best_practices"

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

