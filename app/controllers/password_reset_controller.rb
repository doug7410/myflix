class PasswordResetController < ApplicationController

  def show
    user = User.where(token: params[:id]).first

    if user
      @token = params[:id]
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user

      user.password = params[:password] 
      user.generate_random_token 

      if user.save  
        flash[:success] = "You have changed your password. Please log in"
        redirect_to sessions_new_path
      else
        @token = params[:token]
        @user = user
        render :show
      end
    else
      redirect_to expired_token_path
    end
  end

end  