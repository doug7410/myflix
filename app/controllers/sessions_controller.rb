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

  def forgot_password

  end

  def send_password_email
    if params[:email].blank?
      flash[:warning] = "Please enter your email address"
      redirect_to forgot_password_path
    elsif !email_exists?(params[:email])
      flash[:warning] = "The email you entered is not registered"
      redirect_to forgot_password_path 
    else
      @user = User.where(email: params[:email]).first
      binding.pry
      @reset_password_link = reset_password_path
      MyflixMailer.reset_password(@user, @reset_password_link).deliver 
      render :confirm_password_reset
    end
  end

  def reset_password

  end

  private

  def login_user!(user)
    session[:user_id] = user.id
    flash[:success] = "You have logged in."
    redirect_to home_path
  end

  def email_exists?(email)
    User.where(email: email).exists?
  end
end 