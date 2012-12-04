class MeetingsController < ApplicationController
  # respond_to :json
  def index
    Meeting.update_accepted_meetings
    @meetings = Meeting.not_cancelled.sort_by_status
    # respond_with @meetings
  end

  def create
    @meeting = current_user.mentee_meetings.build(params[:meeting])
    respond_to do |format|
      if @meeting.save
        format.js
      else
        render 'index'
      end
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.mentor = current_user if params[:status] == 'accepted'
    @meeting.mentor = nil if params[:status] == 'available'
    @meeting.status = params[:status]

    respond_to do |format|
      if @meeting.save
        if @meeting.status == "accepted"
          format.js { render :nothing => true }
        else
          if @meeting.status == "matched"
            MeetingRequestMailer.matched(@meeting, params[:message]).deliver
          end
          format.js
          format.json
        end
      else
        render 'index'
      end
    end
  end
end