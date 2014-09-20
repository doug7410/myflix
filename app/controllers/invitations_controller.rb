class InvitationsController < ApplicationController
  before_action :require_user 

  def new
    @invitation = Invitation.new
    # binding.pry
  end 

  def create
    @invitation = current_user.invitations.build(invitation_params)
    if @invitation.save
      MyflixMailer.delay.send_invite_email(@invitation)
      flash[:success] = "You just sent an invitation to #{@invitation.recipient_name} at #{@invitation.recipient_email}"
      redirect_to new_invitation_path  
    else
      flash[:warning] = "Please fix the errors below."
      render :new
    end
  end

  private

    def invitation_params
      params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
    end
end 