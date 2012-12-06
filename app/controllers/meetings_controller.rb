class MeetingsController < ApplicationController
  def index
    Meeting.update_accepted_meetings
    @meetings = Meeting.active(params[:page])
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

    @meeting.status = params[:status]
    @meeting.mentor = current_user if @meeting.matched?

    if @meeting.save
      unless @meeting.send_match_message(params[:message])
        render :nothing => true
      end
    else
      render 'error'
    end
  end
end