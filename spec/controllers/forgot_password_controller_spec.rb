require 'spec_helper'

describe ForgotPasswordController do
	describe "POST create" do
	  context "with blank input" do
	    it "redirects to the forgot password page if email is blank" do
	      post :create, email: ''
	      expect(response).to redirect_to forgot_password_path
	    end

	    it "sets the error message" do
	    	post :create, email: ''
	    	expect(flash[:warning]).to eq("Please enter your email address")
	    end  
	  end

	  context "with existing email" do
	    after { ActionMailer::Base.deliveries.clear }
	
	    it "redirects to the confirm_password_reset page" do
	      bob = Fabricate(:user)
	      post :create, email: bob.email 
	      expect(response).to redirect_to   forgot_password_confirmation_path
	    end
	
	    it "sends an email to the correct recipent" do
	      Fabricate(:user, email: "bob@bob.com")
	      post :create, email: "bob@bob.com" 
	      expect(ActionMailer::Base.deliveries.last.to).to eq(["bob@bob.com"]) 
	    end
	  end

	  context "with non-existiing email" do
	  	it "redirects to the forgot password" do
	      post :create, email: 'some@email.com'
	      expect(response).to redirect_to forgot_password_path
	    end

	    it "sets the error message" do
	    	post :create, email: 'some@email.com'
	    	expect(flash[:warning]).to eq("The email you entered is not registered")
	    end
	  end 
	end 
end 