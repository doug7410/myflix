class UsersController < ApplicationController

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

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end