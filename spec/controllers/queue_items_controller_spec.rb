require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items to the queue items of the logged in user" do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      queue_iems1 = Fabricate(:queue_item, user: current_user )
      queue_iems2 = Fabricate(:queue_item, user: current_user )
      get :index
      expect(assigns(:queue_items)).to match_array([queue_iems1, queue_iems2])
    end

    it "redirects to the log in page if not logged in" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to sessions_new_path 
    end
  end     
end