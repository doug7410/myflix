require 'spec_helper'

describe ReviewsController do
  context "the user is logged in" do
    context "with valid input" do
      let(:video) { Fabricate(:video) }

      before do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
      end

      it "redirects to the video page" do
        post :create, review: {rating: 3, body: "i am a review"}, video_id: video.id
        expect(response).to redirect_to video_path(video)
      end
      it "saves the review to the database" do 
        post :create, review: {rating: 3, body: "i am a review"}, video_id: video.id
        expect(video.reviews.count).to eq(1)
      end
      it "makes sure the review has a creator" do
        post :create, review: {rating: 3, body: "i am a review"}, video_id: video.id
        expect(video.reviews.first.creator).to be_truthy
      end
      it "sets the flash message" do
        post :create, review: {rating: 3, body: "i am a review"}, video_id: video.id
        expect(flash[:success]).to be_truthy
      end
    end

    context "with invalid input" do
      it "sets the @reviews for the current video" do
        video = Fabricate(:video)
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        post :create, review: {body: "i am a review"}, video_id: video.id
        expect(assigns(:reviews)).to eq(video.reviews.all)
      end
      it "renders the video template" do 
        video = Fabricate(:video)
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        post :create, review: {body: "i am a review"}, video_id: video.id
        expect(response).to render_template 'videos/show'
      end      
    end
  end

  context "the user is not logged in" do 
     it "redirects to the log in path" do
        video = Fabricate(:video)
        session[:user_id] = nil
        post :create, review: {body: "i am a review"}, video_id: video.id
        expect(response).to redirect_to sessions_new_path
     end
  end
end