require 'spec_helper'

describe 'Meetings pages', :js => true do
  
   subject { page }
    
  describe 'Meeting requests' do
    let!(:m1) { create(:meeting, :description => "foo") }
    let!(:m2) { create(:matched_meeting, :description => "bar") } 
    let!(:m3) { create(:cancelled_meeting, :description => "hat") }

    before { visit meetings_path }

    it 'Should show all meetings with available and matched status' do
      visit meetings_path
      debugger
      page.should have_content(m1.description)
      page.should have_content(m2.description)
      page.should_not have_content(m3.description)
    end
  end

  context 'When user is logged in' do
    before { click_link "Sign in via Github" }

    it 'shows "sign out" and username links in navigation' do
      page.should have_link("Sign Out")
      page.should have_link("Bob")
    end
  end
  #   context 'user clicks on username in navigation' do
  #     before { click_link user.name }
  #     it 'directs to user profile page'
  #   end

  #   it 'shows the request form' do
  #     page.should have_link("Submit")
  #   end

  #   context 'user accepts a meeting' do
  #     let!(:available_meeting) { create(:meeting, :description => "foo") }
  #     before { click_button "Accept" }
  #     it 'shows the contact form' do
  #       page.should have_link("Contact Mentee")
  #     end

  #     it 'changes the status of the meeting to matched' do
  #       page.should have_content("Matched")
  #     end

  #     context 'user clicks submit button' do
  #       before { click_button "Contact Mentee" }
  #       it 'sends an email to the mentee'

  #       it 'hides the contact form' do
  #         page.should_not have_link("Contact Mentee")
  #       end
  #     end
  #   end

  #   context 'user has a matched meeting' do
  #     let!(:user) { create(:user) }
  #     let!(:m4) { create(:matched_meeting, :mentee => user) }

  #     it 'shows cancel and "we met" buttons' do
  #       page.should have_link("Cancel")
  #       page.should have_link("We met!")
  #     end
  #   end

  #   context 'user has an available meeting' do
  #     let!(:user) { create(:user) }
  #     let!(:m4) { create(:meeting, :mentee => user) }

  #     it 'shows cancel buttons' do
  #       page.should have_link("Cancel")
  #     end

  #     it 'shows status as waiting' do
  #       page.should have_content("Waiting...")
  #     end

  #     context 'user clicks cancel button' do
  #       before { click_button "Cancel" }
  #       it "hides the meeting" do
  #         page.should_not have_content(m4.description)
  #       end
  #     end

  #     context 'user clicks "we met" button' do
  #       before { click_button "We met!" }
  #       it 'hides the meeting' do
  #         page.should_not have_content(m4.description)
  #       end
  #     end
  #   end

  #   context 'user clicks submit button' do
  #     it 'creates a new meeting' do
  #       expect { click_button "Submit" }.to change(Meeting, :count).by(1)
  #     end
  #   end

  #   context 'user clicks sign out in navigation' do
  #     before { click_button "Sign Out" }
  #     it 'does not show request form' do
  #       page.should_not have_link("Submit")
  #     end
      
  #     it 'shows "sign in via github" in navigation' do
  #       page.should have_link('Sign in via Github')
  #     end

  #   end
  # end

  # context 'When user is not logged in' do
  #   it 'shows "sign in via github" in navigation' do
  #     page.should have_link("Sign in via Github")
  #   end

  #   it 'does not show request form' do
  #     page.should_not have_link("Submit")
  #   end
  # end
end