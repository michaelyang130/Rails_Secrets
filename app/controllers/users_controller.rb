class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :require_correct_user, only: [:show, :edit, :update, :destroy]

  def index
  end

  def create
    new_user = User.create(user_params)
    if new_user.save
      session[:user_id] = new_user.id 
      redirect_to "/users/#{new_user.id}"
    else
      dp
      redirect_to '/users/new'
    end
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @secrets = @user.secrets
    @secrets_liked = @user.secrets_liked
  end

  def update
    # @user = User.find(params[:id]) 
    #   (user_params.delete(:password) if params[:user][:password].blank?)
    # if @user.update_attributes(user_params)
    #   flash[:success] = "Edit Successful."
    #   redirect_to "/users/#{@user.id}"
    # else
    #   flash[:errors] = @user.errors.full_messages
    #   redirect_to "/users/#{@user.id}/edit"
    # end
    # @user = User.where(id: params[:id]).first
    # if @user
    #   @user.update(name: params[:name], email: params[:email])
    #   redirect_to "/users/#{@user.id}"
    # else
    #   flash[:errors] = 'User not updated'
    #   redirect_to "/users/#{@user.id}/edit"
    # end
    # @user = User.update(params[:id], user_params)
    # puts params[:id]
    # redirect_to "/users/#{@user.id}"
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "User successfully updated"
      redirect_to "/users/#{@user.id}"
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to "/users/#{@user.id}/edit"
    end
  end

  def destroy
    User.destroy(params[:id])
    session[:user_id] = nil
    redirect_to '/sessions/new'
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
