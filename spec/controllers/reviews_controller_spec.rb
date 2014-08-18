require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    it_behaves_like "require log in" do
      let(:action) { post :create, review: {body: "i am a review"}, video_id: Fabricate(:video).id }
    end
    
    let(:video) { Fabricate(:video) }

    before { set_current_user }

    context "with valid input" do
      before do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
      end
      
      it "redirects to the video page" do
        expect(response).to redirect_to video
      end

      it "creates the review" do 
        expect(video.reviews.count).to eq(1)
      end

      it "makes sure the review is associated with the current_user" do
        expect(Review.first.creator).to eq(current_user)
      end

      it "makes sure the review is associated with the video" do
        expect(Review.first.video).to eq(video)
      end

      it "sets the flash message" do
        post :create, review: {rating: 3, body: "i am a review"}, video_id: video.id
        expect(flash[:success]).to be_truthy
      end
    end

    context "with invalid input" do
      it "does not create a review" do
        post :create, review: {body: "i am a review"}, video_id: video.id
        expect(Review.count).to eq(0)
      end

      it "sets the @video" do
        post :create, review: {body: "i am a review"}, video_id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "sets the @reviews for the current video" do
        review = Fabricate(:review, video: video)
        post :create, review: {body: "i am a review"}, video_id: video.id
        expect(assigns(:reviews)).to match_array([review])
      end
      it "renders the video/show template" do 
        post :create, review: {body: "i am a review"}, video_id: video.id
        expect(response).to render_template 'videos/show'
      end      
    end
  end
end