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

    if @meeting.save && @meeting.status == "matched"
      MeetingRequestMailer.matched(@meeting, params[:message]).deliver
    elsif @meeting.status != 'completed'
      render :nothing => true
    end
  end
end