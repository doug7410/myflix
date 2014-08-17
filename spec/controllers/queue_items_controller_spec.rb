require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items to the queue items of the logged in user" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_iems1 = Fabricate(:queue_item, user: bob )
      queue_iems2 = Fabricate(:queue_item, user: bob )
      get :index
      expect(assigns(:queue_items)).to match_array([queue_iems1, queue_iems2])
    end

    it "redirects to the log in page if not logged in" do
      get :index
      expect(response).to redirect_to sessions_new_path 
    end
  end

  describe "POST create" do
    it "redirects to to my_queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.all.count).to eq(1)
    end

    it "creates a queue_item associated with the video" do
      set_current_user 
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates a queue item associated with the logged in user" do
      bob = Fabricate(:user)
      set_current_user(bob) 
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(bob)
    end

    it "add the queue item to the end of the queue" do
      bob = Fabricate(:user)
      set_current_user(bob)
      the_office = Fabricate(:video)
      Fabricate(:queue_item,video: the_office, user: bob)
      mad_men = Fabricate(:video)
      post :create, video_id: mad_men.id
      mad_men_queue_item = QueueItem.where(video_id: mad_men.id, user_id: bob.id).first
      expect(mad_men_queue_item.list_order).to eq(2)
    end

    it "does not save the queue item if the users queue allready has the video" do
      bob = Fabricate(:user)
      set_current_user(bob)
      mad_men = Fabricate(:video)
      Fabricate(:queue_item, user: bob, video: mad_men)
      post :create, video_id: mad_men.id
      expect(bob.queue_items.count).to eq(1)
    end

    it "redirects to the login page if the user is not signed in" do
      post :create, video_id: 13
      expect(response).to redirect_to sessions_new_path
    end
  end

  describe "POST destroy" do
    it "redirects to the my queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      post :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item = Fabricate(:queue_item, user: bob)
      post :destroy, id: queue_item.id
      expect(bob.queue_items.count).to eq(0)
    end

    it "does not delete the queue item if it's not in the logged in user's queue" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item1 = Fabricate(:queue_item, user: bob)
      doug = Fabricate(:user)
      queue_item2 = Fabricate(:queue_item, user_id: doug.id)
      post :destroy, id: queue_item2.id
      expect(QueueItem.count).to eq(2)
    end

    it "re-orders the remaining queue items" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item1 = Fabricate(:queue_item, user: bob, list_order: 1)
      queue_item2 = Fabricate(:queue_item, user: bob, list_order: 2)
      queue_item3 = Fabricate(:queue_item, user: bob, list_order: 3)
      post :destroy, id: queue_item2.id
      expect(queue_item1.reload.list_order).to eq(1)
      expect(queue_item3.reload.list_order).to eq(2)
    end
    
    it "redirects to login page if the user is not logged in" do
      queue_item = Fabricate(:queue_item)
      post :destroy, id: queue_item.id
      expect(response).to redirect_to sessions_new_path
    end
  end     

  describe "PATCH update" do
    context "with valid inputs" do

      let(:bob) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: bob,  video: video, list_order: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: bob,  video: video, list_order: 2) }
      
      before { set_current_user(bob) }

      it "redirects to my_queue page if logged in" do
        patch :update, queue_items: [{id: queue_item1.id, list_order: 2}, {id: queue_item2.id, list_order: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "re-orders the queue items" do
        patch :update, queue_items: [{id: queue_item1.id, list_order: 2}, {id: queue_item2.id, list_order: 1}]
        expect(bob.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the list_order of queue items" do
        patch :update, queue_items: [{id: queue_item1.id, list_order: 4}, {id: queue_item2.id, list_order: 3}]
        expect(bob.queue_items.map(&:list_order)).to eq([1,2])
      end
    end 

    context "with invalid inputs" do

      let(:bob) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: bob,  video: video, list_order: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: bob,  video: video, list_order: 2) }
      
      before { set_current_user(bob) }

      it "redirects to the my queue page" do
        queue_item1 = Fabricate(:queue_item, user: bob)
        queue_item2 = Fabricate(:queue_item, user: bob)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 2}, {id: queue_item2.id, list_order: 3.5}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        queue_item1 = Fabricate(:queue_item, user: bob, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: bob, list_order: 2)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 2}, {id: queue_item2.id, list_order: 1.2}]
        expect(flash[:warning]).to be_present
      end

      it "does not change the queue items" do
        queue_item1 = Fabricate(:queue_item, user: bob, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: bob, list_order: 2)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 3}, {id: queue_item2.id, list_order: 3.5}]
        expect(queue_item1.reload.list_order).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to log in path if the user is not logged in" do
        patch :update
        expect(response).to redirect_to sessions_new_path 
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        bob = Fabricate(:user)
        frank = Fabricate(:user)
        set_current_user(bob)
        queue_item1 = Fabricate(:queue_item, user: bob, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: frank, list_order: 2)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 3}, {id: queue_item2.id, list_order: 5}]
        expect(queue_item2.reload.list_order).to eq(2)
      end
    end
  end
end

