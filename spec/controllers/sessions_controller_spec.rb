require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to the home page if a user is logged in" do
      session[:user_id] = Fabricate(:user).id 
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    let!(:bob) { Fabricate(:user, email: "bob@bob.com") }

    it "sets user to the user with a matching email" do 
      post :create, email: "bob@bob.com"
      expect(assigns(:user)).to eq(bob)
    end

    context "successfull login" do
      before do
        post :create, email: "bob@bob.com", password: "password"
      end
      
      it "logs in user if email and password matches the database" do
        expect(session[:user_id]).to eq(bob.id)
      end

      it "redirects to the home page if email and password matches the database" do
        expect(response).to redirect_to home_path
      end
    end

    it "shows an error message if the email or password did not match and renders the new tempalate" do
      post :create, email: "bob@bob.com", password: ""
      expect(flash[:danger]).to eq("Something was wrong with your username or password.")
      expect(response).to render_template :new
    end
   end

  describe "GET destroy" do

    it "loggs the user out" do 
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "shows a success message and redirects to the home page" do
      get :destroy
      expect(flash[:success]).to eq("You have logged out.")
      expect(response).to redirect_to root_path
    end
  end

end