class SessionsController < ApplicationController
  def login
  	user = User.where(email: params[:email]).first
  	if user && user.authenticate(params[:password])
      session[:user_id] = user.id
  		redirect_to "/users/#{user.id}"
  	else
  		flash[:errors] = 'Invalid'
  		redirect_to '/sessions/new'
  	end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/sessions/new'
  end

  def new
  end
end
