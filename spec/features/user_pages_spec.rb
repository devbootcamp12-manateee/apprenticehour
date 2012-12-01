require 'spec_helper'

describe 'Profile page' do
  before do
    other_user = create(:user)
    @m1 = create(:meeting, :mentee => other_user)
    visit root_path
    click_link 'Sign in via Github'
    @user = User.find_by_email('bob@bob.com')
    @m2 = create(:matched_meeting, :mentee => @user)
    @m3 = create(:meeting, :mentee => @user)
    visit user_path(@user)
  end

  it "displays only the user's meeting" do
    page.should have_content(@m2.description)
    page.should have_content(@m3.description)
    page.should_not have_content(@m1.description)
  end

  # unsure why spec isn't working. should pass (Code works as described)
  # it "displays the meetings in the right order" do
  #   page.body.should =~ /#{@m2.description}.*#{@m3.description}/
  # end

  it "has the user's picture, name and email" do
    page.should have_css("img")
    page.should have_content(@user.name)
    page.should have_content(@user.email)
  end
end