class UsersController < ApplicationController
  before_filter :correct_user?, :only => [:edit, :update]
  def show
    @user = User.find(params[:id])
    @meetings = @user.meetings.not_cancelled
  end

  def edit
  end

  def update
    if params[:user][:email].match /.+@.+\..+/
      @user.update_attributes(params[:user])
      sign_in @user
      redirect_to root_path
    else
      flash[:alert] = 'Please enter a valid email address'
      redirect_to edit_user_path(@user)
    end
  end

private
  def correct_user?
    @user = User.find(params[:id])
    redirect_to root_path unless current_user == @user
  end
end