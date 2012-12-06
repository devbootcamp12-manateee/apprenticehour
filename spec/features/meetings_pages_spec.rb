require 'spec_helper'

describe 'Meetings pages' do
  
  subject { page }
    
  describe 'Meeting requests' do
    let!(:m1) { create(:meeting, :description => "foo") }
    let!(:m2) { create(:matched_meeting, :description => "bar") } 
    let!(:m3) { create(:cancelled_meeting, :description => "shoe") }

    before { visit meetings_path }

    it 'Should show all meetings with available and matched status' do
      page.should have_content(m1.description)
      page.should have_content(m2.description)
      page.should_not have_content(m3.description)
    end
  end

  context 'When user is logged in' do
    before do
      visit meetings_path 
      # click_link uses fake omniauth data in spec_helper.rb file
      click_link "Sign in via Github"
    end

    it 'shows "sign out" and username links in navigation' do
      page.should have_link("Sign Out")
      page.should have_link("Bob")
    end

    context 'user clicks on username in navigation' do
      before { click_link user.name }
      it 'directs to user profile page'
    end

    it 'shows the new meeting form' do
      page.should have_button("Submit")
    end

    context 'user accepts a meeting', :js => true do
      let!(:available_meeting) { create(:meeting, :description => "foo") }
      before do
        visit meetings_path
        click_button "Accept"
      end

      it 'shows the contact form' do
        page.should have_button("Send Email")
        page.should have_button("Nevermind")
      end

      it 'changes the status of the meeting to matched for other users' do
        click_link "Sign Out"
        page.should have_css(".matched_image")
      end

      context 'user clicks submit button' do
        before { click_button "Send Email" }
        it 'sends an email to the mentee'
        it 'hides the contact form' do
          page.should have_selector("#message", visible: false)
        end
      end
    end

    context 'user has a matched meeting' do
      let!(:m4) { create(:matched_meeting, :mentee_id => 1) }
      before { visit meetings_path }

      it 'shows cancel and "we met" buttons' do
        page.should have_button("Cancel")
        page.should have_button("We Met!")
      end
    end

    context 'user has an available meeting' do
      let!(:m4) { create(:meeting, :mentee_id => 1) }
      before { visit meetings_path }

      it 'shows cancel buttons' do
        page.should have_button("Cancel")
      end

      it 'shows status as waiting' do
        page.should have_css(".available_image")
      end

      context 'user clicks cancel button', :js => true do
        before { click_button "Cancel" }

        it "changes the status to cancelled" do
          page.should have_css(".cancelled_image")
        end
      end

      context 'user clicks "we met" button', :js => true do
        let!(:m5) { create(:matched_meeting, :mentee_id => 1) }
        before do
          visit meetings_path
          click_button "We Met!"
        end

        it 'shows status as completed' do
          page.should have_css(".completed_image")
        end
      end
    end

    context 'user clicks submit button' do
      before do
        Topic.create(:description => "Rails")
        visit meetings_path
        fill_in "meeting[description]", :with => "I need help"
        fill_in "meeting[neighborhood]", :with => "mission"
        page.select( "Rails", :from => "meeting[topic_id]" )
      end

      it 'creates a new meeting' do
        expect { click_button "Submit" }.to change(Meeting, :count).by(1)
      end
    end

    context 'user clicks sign out in navigation' do
      before { click_link "Sign Out" }
      it 'does not show request form' do
        page.should_not have_button("Submit")
      end
      
      it 'shows "sign in via github" in navigation' do
        page.should have_link('Sign in via Github')
      end

    end
  end

  context 'When user is not logged in' do
    it 'shows "sign in via github" in navigation' do
      visit meetings_path
      page.should have_link("Sign in via Github")
    end
  end
end