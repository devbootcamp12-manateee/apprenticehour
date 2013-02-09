class SessionsController < ApplicationController
  def create
    user = User.from_oauth(env['omniauth.auth'])
    sign_in user
    if user.email.empty?
      flash[:alert] = "Please enter an email address"
      redirect_to edit_user_path(user)
    else
      redirect_to root_url
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end