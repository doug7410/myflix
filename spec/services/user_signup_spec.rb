require 'spec_helper'

describe UserSignup do
  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#sign_up" do
    context "valid personal info and valid card" do

      let(:customer) { double(:customer, successful?: true, customer_token: "abcabc")}

      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end



      it "creates the new user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq("abcabc")
      end

      it "makes the user follow the inviter" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: bob.id, recipient_email: "joe@joe.com")
        UserSignup.new(Fabricate.build(:user, email: "joe@joe.com", password: "password", full_name: "Joe Shmoe")).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: 'joe@joe.com').first
        expect(joe.follows?(bob)).to be_truthy
      end

      it "makes the inviter follow the user" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: bob.id, recipient_email: "joe@joe.com")
        UserSignup.new(Fabricate.build(:user, email: "joe@joe.com", password: "password", full_name: "Joe Shmoe")).sign_up("some_stripe_token", invitation.token)
        joe = User.where(email: 'joe@joe.com').first
        expect(bob.follows?(joe)).to be_truthy
      end

      it "expires the token upon acceptance" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: bob.id, recipient_email: "joe@joe.com")
        UserSignup.new(Fabricate.build(:user, email: "joe@joe.com", password: "password", full_name: "Joe Shmoe")).sign_up("some_stripe_token", invitation.token)
        expect(invitation.reload.token).to be_nil
      end               

      it "sends to the right recipient with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "joe@joe.com")).sign_up("some_stripe_token", nil)
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["joe@joe.com"])
      end

      it "has the users name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "joe@joe.com", password: "password", full_name: "Joe Shmoe")).sign_up("some_stripe_token", nil)
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Joe Shmoe")
      end
    end

    context "valid personal info and declined card" do 
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined")
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)

        UserSignup.new(Fabricate.build(:user)).sign_up('123456', nil)
        expect(User.count).to eq (0)
      end
    end

    context "invalid personal info" do      
      
      it "does not create a user" do
        UserSignup.new(User.new( email: "bob@bob.com", password: "")).sign_up("12345", nil)
        expect(User.count).to eq(0)
      end

      it "does not attemt to Charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
        UserSignup.new(User.new( email: "bob@bob.com", password: "")).sign_up("12345", nil)
      end

      it "does not send out the email with invalid inputs" do
        UserSignup.new(User.new( email: "bob@bob.com", password: "")).sign_up("12345", nil)
        expect(ActionMailer::Base.deliveries.count).to eq(0) 
      end
    end
  end
end