require 'spec_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    it_behaves_like "require log in" do
      let(:action) { get :index }
    end

    it "sets the @payments" do
      bob = Fabricate(:user)
      set_current_admin
      payment1 = Fabricate(:payment, user: bob)
      payment2 = Fabricate(:payment, user: bob)
      get :index
      expect(assigns(:payments)).to eq([payment1, payment2])
    end
  end
end