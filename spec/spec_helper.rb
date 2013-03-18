require 'simplecov'
SimpleCov.start
require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before :each do
      DatabaseCleaner.start
    end
    config.after :each do
      DatabaseCleaner.clean
    end
    config.order = "random"
  end

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = Hashie::Mash.new({:provider => 'github',
         :uid => '12345',
         :info => Hashie::Mash.new(:name => 'Bob',
                                   :email => 'bob@bob.com',
                                   :image => 'https://secure.gravatar.com/avatar/e466e786cb4fd0005ad12c648f6dc50f?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png'),
                                   :credentials => Hashie::Mash.new(:token => '1234',
                                                                    :expires_at => Time.now)})
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end