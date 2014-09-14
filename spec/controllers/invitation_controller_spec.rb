require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do  
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end 

    it_behaves_like "require log in" do 
      let(:action) { get :new }
    end    
  end 

  describe 'POST create' do
    it_behaves_like "require log in" do
      let(:action) { post :create }
      end
    
    context 'with valid input' do 
      let(:bob) { Fabricate(:user) } 
      
      before do
        set_current_user(bob)
        post :create, invitation: {recipient_name: "Joe", recipient_email: "joe@joe.com", message: "Hey Joe!"}
      end  
 
      it "creates an invitation associated with the current user" do 
        expect(bob.invitations.count).to eq(1)  
      end

      it "send the invitation email to the invitee" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@joe.com"])
      end

      it "redirects to the invitation new page" do
        expect(response).to redirect_to  new_invitation_path
      end       

      it "sets the flash messsage" do
        expect(flash[:success]).not_to be_nil
      end
 
       
    end 

    context 'with invalid input' do
      let(:bob) { Fabricate(:user) }  
      
      before do 
        set_current_user(bob)  
        ActionMailer::Base.deliveries.clear 
      end

      it "renders the invitation new template" do
        post :create, invitation: {recipient_name: "Joe"}  
        expect(response).to render_template :new
      end
       
      it "does not create a new invitation" do
        post :create, invitation: {recipient_email: "Joe@joe.com"}
        expect(bob.invitations.count).to eq(0)
      end

      it "does not send an eamil" do
        post :create, invitation: {recipient_email: "Joe@joe.com"}
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    
      it "sets @invitation" do
        post :create, invitation: {recipient_email: "Joe@joe.com"}
        expect(assigns(:invitation)).to be_instance_of(Invitation)  
      end

      it "sets the flash error message" do 
        post :create, invitation: {recipient_email: "Joe@joe.com"}
        expect(flash[:warning]).not_to be_nil  
      end

    end 
  end 
end  