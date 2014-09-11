class SessionsController < ApplicationController

  def new
    redirect_to home_path if logged_in?
  end 

  def create
    @user = User.find_by(email: params[:email])
    
    if @user && @user.authenticate(params[:password]) 
      login_user!(@user)
    else
      flash[:danger] = "Something was wrong with your username or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out."
    redirect_to root_path
  end

  private

  def login_user!(user)
    session[:user_id] = user.id
    flash[:success] = "You have logged in."
    redirect_to home_path
  end
end 