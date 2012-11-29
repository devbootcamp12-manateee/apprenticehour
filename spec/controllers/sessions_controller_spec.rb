require 'spec_helper'

describe SessionsController do
  before do
    @fakeauth = Hashie::Mash.new(:provider => 'github',
                                 :uid => '12345',
                                 :info => Hashie::Mash.new(:name => 'Bob',
                                                           :email => 'bob@bob.com',
                                                           :image => 'sasdad'),
                                 :credentials => Hashie::Mash.new(:token => '1234',
                                                                  :expires_at => Time.now))
    @env = Rack::MockRequest.env_for('/', 'omniauth.auth' => @fakeauth)
    SessionsController.action(:create).call(@env)
  end

  describe 'POST #create' do
    it "sets a remember_token" do
      User.find_by_uid('12345').remember_token.should_not be_nil
    end

    it "sets the current_user" do
      sessions_controller = @env['action_controller.instance']
      sessions_controller.instance_variable_get(:@current_user).should eq(User.first)
    end
  end

  describe 'DELETE #destroy' do
    it "sets the current_user to nil" do
      delete :destroy
      assigns(:current_user).should be_nil
    end
  end
end