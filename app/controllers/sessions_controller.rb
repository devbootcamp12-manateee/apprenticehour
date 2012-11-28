class SessionsController < ApplicationController
  def create
    user = User.from_oauth(env['omniauth.auth'])
    sign_in user
    redirect_to root_url
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end