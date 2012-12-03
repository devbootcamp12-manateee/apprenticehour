class MeetingsController < ApplicationController
  # respond_to :json
  def index
    Meeting.update_accepted_meetings
    @meetings = Meeting.not_cancelled.sort_by_status
    # respond_with @meetings
  end

  def create
    @meeting = current_user.mentee_meetings.build(params[:meeting])
    logger.debug(@meeting.inspect)
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

    @meeting.mentor_id = current_user.id if params[:status] == "matched"
    @meeting.status = params[:status]

    respond_to do |format|
      if @meeting.save && @meeting.status != "matched"
        format.js
      else
        render 'index'
      end
    end
  end
end