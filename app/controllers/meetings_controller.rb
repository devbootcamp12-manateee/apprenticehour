class MeetingsController < ApplicationController
  def index
    Meeting.update_accepted_meetings
    @meetings = Meeting.not_cancelled.sort_by_status.paginate(:page => params[:page], :per_page => 20)
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
    if !Meeting.valid_transition?(@meeting.status, params[:status])
      render :template => 'meetings/error.js.erb'
    else
      @meeting.mentor = current_user if params[:status] == 'matched'
      @meeting.mentor = nil if params[:status] == 'available'
      @meeting.status = params[:status]

      if @meeting.save
        if @meeting.status == "matched"
          MeetingRequestMailer.matched(@meeting, params[:message]).deliver
        elsif @meeting.status == 'available' || @meeting.status == 'accepted'
          render :nothing => true
        end
      else
        render :template => 'meetings/error.js.erb'
      end
    end
  end
end