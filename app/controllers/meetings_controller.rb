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

    if @meeting.status == 'matched' && params[:status] == 'matched'
      render :template => 'meetings/error.js.erb'
    else
      @meeting.mentor = current_user if params[:status] == 'accepted'
      @meeting.mentor = nil if params[:status] == 'available'
      @meeting.status = params[:status]

      if @meeting.save && @meeting.status == "matched"
        MeetingRequestMailer.matched(@meeting, params[:message]).deliver
      elsif @meeting.status != 'completed' && @meeting.status != 'cancelled'
        render :nothing => true
      end
    end
  end
end