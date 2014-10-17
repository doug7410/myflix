require 'spec_helper'

describe UsersController do
  after do
    ActionMailer::Base.deliveries.clear
  end
  
  describe "GET new" do
    it "sets the @user to a new User" do   
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
    
    it "redirects to the home page if a user is logged in" do
      set_current_user 
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "successful user sign up" do  
      let(:result) { double(:sign_up_result, successful?: true)}
      before do
        allow_any_instance_of(UserSignup).to receive(:sign_up) { result }
      end
      
      it "redirects to the login path if the user has been saved" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sessions_new_path
      end

      it "creates a notice if the user has been saved" do 
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:success]).to eq("Thank you for registering with MyFlix!")
      end
    end

    context "filed user sign up" do
      let(:result) { double(:sign_up_result, successful?: false, error_message: "error message") }
        
      before do
       allow_any_instance_of(UserSignup).to receive(:sign_up) { result }
      end

      it "renders the new template" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123456'
        expect(response).to render_template :new
      end

      it "sets the flash errror message" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123456'
        expect(flash[:warning]).to eq("error message")
      end  
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the users new template" do
      invitaion = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitaion.token
      expect(response).to render_template :new
    end
    
    it "sets the @user with the recipient's email" do   
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets the @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to the expired token page with invalid token" do
      get :new_with_invitation_token, token: '123456'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "GET show" do
    it_behaves_like "require log in" do
      let(:action) { get :show, id: 2 }
    end

    context "the user is logged in" do

      before { set_current_user }

      it "sets the @user to the user being viewed" do
        bob = Fabricate(:user)
        get :show, id: bob.id
        expect(assigns(:user)).to eq(bob) 
      end

      it "sets the @queue_items to the queue items of the user being viewed" do
        bob = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: bob)
        get :show, id: bob.id
        expect(assigns(:queue_items)).to eq([queue_item])
      end

      it "sets the @reviews to the users reviews" do
        bob = Fabricate(:user)
        house = Fabricate(:video)
        review1 = Fabricate(:review, user: bob, video: house)
        review2 = Fabricate(:review, user: bob, video: house)
        get :show, id: bob.id
        expect(assigns(:reviews)).to eq([review1, review2])
      end

      it "renders the show user page for the user being viewd" do
        bob = Fabricate(:user)
        get :show, id: bob.id
        expect(response).to render_template :show
      end
    end
  end
end