class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    if logged_in?
      redirect_to home_path 
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save 
      flash[:success] = "You were registered."
      redirect_to sessions_new_path
    else
      render :new 
    end
  end

  def show
    @user = User.find(params[:id])
    @queue_items = QueueItem.where(user: @user)
    @reviews = Review.where(user: @user)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end