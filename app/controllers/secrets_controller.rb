class SecretsController < ApplicationController
  before_action :require_login, only: [:index, :create, :destroy]

  def index
    @secrets = Secret.all
  end

  def create
    @user = User.find(session[:user_id])
    if @user.secrets.create(secret_params)
      flash[:success] = 'Secret Successfully Created'
      redirect_to "/users/#{@user.id}"
    else
      flash[:errors] = @user.secrets.errors.full_messages
      redirect_to "/users/#{@user.id}"
    end
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
    secret = Secret.find(params[:id])
    secret.destroy if secret.user == current_user
    redirect_to "/users/#{current_user.id}"
  end

  private
  def secret_params
    params.require(:secret).permit(:content)
  end
end
