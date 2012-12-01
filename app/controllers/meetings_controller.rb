class MeetingsController < ApplicationController
  def index
    @meetings = Meeting.all
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

    respond_to do |format|
      if @meeting.update_attributes(:status => params[:status], :mentor_id => current_user.id)
        format.js
      else
        render 'index'
      end
    end
  end
end