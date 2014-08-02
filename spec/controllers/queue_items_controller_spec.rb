require 'spec_helper'

describe QueueItemsController do
  context "the user is logged in" do
    it "renders the my queue page" do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      get :index, user_id: current_user.id
      expect(response).to render_template :index
    end
  end
end