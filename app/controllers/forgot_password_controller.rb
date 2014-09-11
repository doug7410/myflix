class ForgotPasswordController < ApplicationController
	
	def create
    email = params[:email]

    if email.blank?
      flash[:warning] = "Please enter your email address"
      redirect_to forgot_password_path
    elsif !email_exists?(email)
      flash[:warning] = "The email you entered is not registered"
      redirect_to forgot_password_path  
    else
      @user = User.where(email: email).first
      MyflixMailer.send_password_reset(@user).deliver 
      redirect_to forgot_password_confirmation_path   
    end 
  end
 
  private 

  def email_exists?(email)
    User.where(email: email).exists?
  end 

  
end