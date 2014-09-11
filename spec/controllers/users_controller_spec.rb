require 'spec_helper'

describe UsersController do
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
    context "input is valid" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end 
      
      it "creates the new @user" do
        expect(User.count).to eq(1)
      end

      it "creates a notice if the user has been saved" do 
        expect(flash[:success]).to eq("You were registered.")
      end

      it "redirects to the login path if the user has been saved" do
        expect(response). to redirect_to sessions_new_path
      end
    end

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends to the right recipient with valid inputs" do
        post :create, user: {email: "bob@bob.com", password: "password", full_name: "bob bob"}  
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["bob@bob.com"])
      end

      it "has the users name with valid inputs" do
        post :create, user: {email: "bob@bob.com", password: "password", full_name: "bob bob"} 
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to have_text("bob bob")
      end

      it "does not send out the email with invalid inputs" do
        post :create, user: { email: "bob@bob.com" }
        expect(ActionMailer::Base.deliveries.count).to eq(0) 
      end
    end

    context "input is invalid" do
      it "renders the new user template if validation fails" do
        post :create, user: {email: "bob@bob.com", password: ""}
        expect(User.count).to eq(0)
        expect(response).to render_template :new
      end 
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