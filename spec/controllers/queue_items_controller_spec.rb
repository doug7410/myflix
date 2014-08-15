require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets the @queue_items to the queue items of the logged in user" do
      set_current_user
      queue_iems1 = Fabricate(:queue_item, user: current_user )
      queue_iems2 = Fabricate(:queue_item, user: current_user )
      get :index
      expect(assigns(:queue_items)).to match_array([queue_iems1, queue_iems2])
    end

    it_behaves_like "require log in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:video) { Fabricate(:video)}

    before do
      set_current_user
    end

    it_behaves_like "the user is logged in" do
      let(:action) { post :create, video_id: video.id }
      let(:redirect_page) { my_queue_path }
    end

    it_behaves_like "require log in" do
      let(:action) { post :create, video_id: Fabricate(:video).id }
    end

    it "associates the queue_item with the video if it's not in the queue yet" do
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "adds the video to the users" do
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(current_user)
    end

    it "saves the queue item if it's not in the queue yet" do
      post :create, video_id: video.id
      expect(QueueItem.all.count).to eq(1)
    end

    it "does not save the queue item if the users queue allready has the video" do
      queue_item = Fabricate(:queue_item, user: current_user, video: video)
      post :create, video_id: video.id
      expect(current_user.queue_items.count).to eq(1)
    end
    
    it "add the queue item to the end of the queue" do
      Fabricate(:queue_item, video: video, user: current_user)
      mad_men = Fabricate(:video)
      post :create, video_id: mad_men.id
      mad_men_queue_item = QueueItem.where(video_id: mad_men.id, user_id: current_user.id).first
      expect(mad_men_queue_item.list_order).to eq(2)
    end
  end

  describe "POST destroy" do
    before do
      set_current_user
    end

    it_behaves_like "the user is logged in" do
      let(:action) { post :destroy, id: Fabricate(:queue_item).id }
      let(:redirect_page) { my_queue_path }
    end

    it_behaves_like "require log in" do
      let(:action) { post :destroy, id: Fabricate(:queue_item).id }
    end

    it "deletes the queue item" do
      queue_item = Fabricate(:queue_item, user: current_user)
      post :destroy, id: queue_item.id
      expect(current_user.queue_items.count).to eq(0)
    end

    it "does not delete the queue item if the queue item is not in the users queue" do
      queue_item1 = Fabricate(:queue_item, user: current_user)
      doug = Fabricate(:user)
      queue_item2 = Fabricate(:queue_item, user_id: doug.id)
      post :destroy, id: queue_item2.id
      expect(QueueItem.count).to eq(2)
    end

    it "re-orders all the other queue items" do
      queue_item1 = Fabricate(:queue_item, user: current_user, list_order: 1)
      queue_item2 = Fabricate(:queue_item, user: current_user, list_order: 2)
      queue_item3 = Fabricate(:queue_item, user: current_user, list_order: 3)
      post :destroy, id: queue_item2.id
      expect(queue_item1.reload.list_order).to eq(1)
      expect(queue_item3.reload.list_order).to eq(2)
    end
  end     

  describe "PATCH update" do
    before { set_current_user }

    context "with valid inputs" do  
      it_behaves_like "the user is logged in" do
        let(:action) { patch :update }
        let(:redirect_page) { my_queue_path }
      end

      it "updates and normalizes the list_order of queue items" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, video: video1)
        queue_item2 = Fabricate(:queue_item, user: user, video: video2)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 2}, {id: queue_item2.id, list_order: 4}]
        expect(queue_item1.reload.list_order).to eq(1)
        expect(queue_item2.reload.list_order).to eq(2)
      end
    end 

    context "with invalid inputs" do
      it_behaves_like "the user is logged in" do
        let(:action) { patch :update }
        let(:redirect_page) { my_queue_path }
      end

      it "sets the flash error message" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: user, list_order: 2)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 2}, {id: queue_item2.id, list_order: 1.2}]
        expect(flash[:warning]).to be_present
      end

      it "does not change the queue items" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: user, list_order: 2)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 3}, {id: queue_item2.id, list_order: 3.5}]
        expect(queue_item1.reload.list_order).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it_behaves_like "require log in" do
        let(:action) { patch :update }
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        user = Fabricate(:user)
        user1 = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: user1, list_order: 2)
        patch :update, queue_items: [{id: queue_item1.id, list_order: 3}, {id: queue_item2.id, list_order: 5}]
        expect(queue_item2.reload.list_order).to eq(2)
      end
    end
  end
end

