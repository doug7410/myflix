require 'spec_helper'

describe PasswordResetController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      bob = Fabricate(:user)
      bob.update_column(:token, '12345')
      get :show, id: '12345' 
      expect(response).to render_template :show
    end

    it "redirects to the expired token page if the token has expired" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end

    it "sets @token" do
      bob = Fabricate(:user)
      bob.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end
  end

   describe "POST create" do
    context "with valid token and valid input" do
      it "redirects to the log in page" do
        bob = Fabricate(:user)
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to sessions_new_path
      end  

      it "resets the users password" do
        bob = Fabricate(:user, password: 'old_password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(bob.reload.authenticate('new_password')).to eq(bob)
      end

      it "sets the flash success message" do
        bob = Fabricate(:user, password: 'old_  password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present
      end

      it "resets the token" do
        bob = Fabricate(:user, password: 'old_  password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(bob.reload.token).not_to eq('12345')
        expect(bob.reload.token).not_to be_nil
      end
    end

    context "with valid token and invalid input" do
      it "does not reset password if there are validation errors" do
        bob = Fabricate(:user, password: 'old_password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: '123' 
        expect(bob.reload.authenticate('123')).to eq(false)
      end

      it "displays an error message if there are validation errors" do
        bob = Fabricate(:user, password: 'old_password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: '123'
        expect(bob.errors).not_to be_nil
      end 

      it "sets @user" do
        bob = Fabricate(:user, password: 'old_password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: '123'
        expect(assigns(:user)).to eq(bob)
      end

      it "sets @token" do
        bob = Fabricate(:user, password: 'old_password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: '123'
        expect(assigns(:token)).to eq('12345')
      end
       
      it "renders the password_reset show template" do
        bob = Fabricate(:user, password: 'old_password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: '123'
        expect(response).to render_template :show
      end  
    end

    context "with invalid token" do
      it "redirects to the invalid token path" do
        post :create, password: 'password', token: '12345'
        expect(response).to redirect_to expired_token_path
      end
    end
   end
end