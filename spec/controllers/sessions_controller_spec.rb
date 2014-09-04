require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new page if the user is not logged in" do
      get :new
      expect(response).to render_template :new
    end 

    it "redirects to the home page if a user is logged in" do
      session[:user_id] = Fabricate(:user).id 
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "users credentials are valid" do
      let(:bob) { Fabricate(:user) }

      before do
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
      let(:bob) { Fabricate(:user) }

      before do
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
      set_current_user
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

  describe "POST send_password_email" do
    context "with invalid input" do
      it "redirects to the forgot password page if email is blank" do
        post :send_password_email, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "redirects to the forgot password page if email does not exist in system" do
        post :send_password_email, email: 'some@email.com'
        expect(response).to redirect_to forgot_password_path
      end
    end

    context "with valid input" do
      after { ActionMailer::Base.deliveries.clear }

      it "renders the confirm_password_reset template" do
        bob = Fabricate(:user)
        post :send_password_email, email: bob.email 
        expect(response).to render_template :confirm_password_reset
      end

      it "sends an email to the correct recipent if they exist in the system" do
        bob = Fabricate(:user, email: "bob@bob.com")
        post :send_password_email, email: bob.email 
        expect(ActionMailer::Base.deliveries.last.to).to eq(["bob@bob.com"])
      end

      it "assigngs @reset_password_link" do  
        bob = Fabricate(:user) 
        post :send_password_email, email: bob.email 
        expect(assigns(@reset_password_link)).to eq(reset_password_path)
      end

      #it "send an email with a link to reset the password" do
      #  bob = Fabricate(:user) 
      #  post :send_password_email, email: bob.email 
      #  expect(ActionMailer::Base.deliveries.last.to).to have_link(bob.reset_password_link)
      #end
    end
  end
end 