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

  describe "POST create" do
    context "user is logged in" do
      let(:video) { Fabricate(:video)}
      let(:user) { Fabricate(:user)}

      context "video is not in queue yet" do
        before do
          session[:user_id] = user.id
          post :create, video_id: video.id
        end

        it "associates the queue_item with the video" do
          expect(QueueItem.first.video).to eq(video)
        end

        it "associates the queue item with the user" do
          expect(QueueItem.first.user).to eq(user)
        end

        it "saves the queue item" do
          expect(QueueItem.all.count).to eq(1)
        end

        it "redirects to to my_queue page" do
          expect(response).to redirect_to my_queue_path
        end
      end

      context "video is allready in queue" do
        it "does not save the queue item if the users queue allready has the video" do
          session[:user_id] = user.id
          queue_item = Fabricate(:queue_item, user: user, video: video)
          post :create, video_id: video.id
          expect(user.queue_items.count).to eq(1)
        end
      end

      context "user has items in queue" do
        it "add the queue item to the end of the queue" do
          doug = Fabricate(:user)
          session[:user_id] = doug.id
          Fabricate(:queue_item, video: video, user: doug)
          mad_men = Fabricate(:video)
          post :create, video_id: mad_men.id
          mad_men_queue_item = QueueItem.where(video_id: mad_men.id, user_id: doug.id).first
          expect(mad_men_queue_item.list_order).to eq(2)
        end
      end
    end

    context "user is not logged in" do
      it "redirects to the login page if the user is not signed in" do
        session[:user_id] = nil
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to sessions_new_path
      end
    end
  end     
end