class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    if logged_in?
      redirect_to home_path 
    else
      @user = User.new
    end
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation.present?
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params) 
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    if result.successful?
      flash[:success] = "Thank you for registering with MyFlix!"
      redirect_to sessions_new_path
    else
      flash[:warning] = result.error_message
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