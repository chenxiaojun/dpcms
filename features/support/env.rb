# encoding: utf-8

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.
ENV['RAILS_ENV'] = 'test'
ENV['DP_DATABASE_TEST'] ||= 'deshpro_s_i_t'
require 'cucumber/rails'
require 'capybara/poltergeist'

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath

# on mac os execute brew install ChromeDriver
Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new app, browser: :chrome
end
Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: true,
    timeout:   120,
    debug:     false,
    phantomjs_options: ['--load-images=no', '--disk-cache=false'],
    inspector: true,
  }
  Capybara::Poltergeist::Driver.new(app, options)
end
if ENV['CAPYBARA_DRIVER'] == 'chrome'
  Capybara.default_driver = :selenium_chrome
else
  Capybara.default_driver = :poltergeist
end
# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
DatabaseCleaner.strategy = :deletion, { except: %w(affiliates affiliate_apps) }
# DatabaseCleaner.strategy = :transaction

Before do
  DatabaseCleaner.start
end

include Warden::Test::Helpers
After do
  DatabaseCleaner.clean
  Rails.cache.clear
  Warden.test_reset!
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation
