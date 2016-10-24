class LikesController < ApplicationController
before_action :require_login, only: [:create, :destroy]

def create
	secret = Secret.find(params['secret_id'])
	like = Like.create(user: current_user, secret: secret)
	redirect_to '/secrets'
end

def destroy
	like = Like.where(secret_id: params['secret_id'], user_id: session[:user_id]).first.destroy
	redirect_to '/secrets'
end

end

