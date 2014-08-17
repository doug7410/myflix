require 'spec_helper'

describe SessionsController do
  before { set_current_user }

  describe "GET new" do
    it "renders the new page if the user is not logged in" do
      clear_current_user
      get :new
      expect(response).to render_template :new
    end 

    it_behaves_like "the user is logged in" do
      let(:action) { get :new } 
      let(:redirect_page) { home_path }
    end
  end

  describe "POST create" do
    context "users credentials are valid" do
      let!(:bob) { Fabricate(:user) }

      before do
        clear_current_user
        post :create, email: bob.email, password: bob.password
      end

      it "logs the user in" do
        expect(session[:user_id]).to eq(bob.id)
      end

      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end

      it "sets success message" do
        expect(flash[:success]).to be_truthy
      end
    end

    context "users credentials are not valid" do
      let!(:bob) { Fabricate(:user) }

      before do
        clear_current_user
        post :create, email: bob.email, password: bob.password + '123'
      end

      it "does not set the session to the user" do 
        expect(session[:user_id]).to be_nil
      end

      it "sets error message" do
        expect(flash[:danger]).to_not be_blank
      end

      it "renders the new tempalate" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET destroy" do
    before do
      get :destroy
    end

    it "clears the session for the user" do 
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the site root" do
      expect(response).to redirect_to root_path
    end

    it "shows a success message and redirects to the home page" do
      expect(flash[:success]).to eq("You have logged out.")
    end
  end
end