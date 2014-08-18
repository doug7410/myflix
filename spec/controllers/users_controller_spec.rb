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

    context "input is invalid" do
      it "renders the new user template if validation fails" do
        post :create, user: {email: "bob@bob.com", password: ""}
        expect(User.count).to eq(0)
        expect(response).to render_template :new
      end
    end
  end
end

