class MeetingsController < ApplicationController
  # respond_to :json
  def index
    @meetings = Meeting.not_cancelled
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

    @meeting.mentor_id = current_user.id if params[:status] == "matched"
    @meeting.status = params[:status]

    respond_to do |format|
      if @meeting.save
        format.js unless @meeting.status == "matched"
      else
        render 'index'
      end
    end
  end
end