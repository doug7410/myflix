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

    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )
      if charge.successful? 
        @user.save 
        handle_invitation
        MyflixMailer.welcome_user_email(@user).deliver  
        flash[:success] = "Thank you for registering with MyFlix!"
        redirect_to sessions_new_path
      else
        flash[:warning] = charge.error_message
        render :new
      end
    else
      flash[:warning] = "There was a problem with your info. Please check the form below." 
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

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil) 
    end
  end

end