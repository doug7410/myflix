require 'spec_helper'

describe VideosController do
  let(:video) {Fabricate(:video)}
  
  describe "GET show" do
    it_behaves_like "require log in" do
      let(:action) { get :show, id: video.id }
    end

    before { set_current_user }
 
    it "sets the requested video to @video" do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets the @reviews that belong to the video" do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2]) 
    end

    it "sets @review to a blank review" do
      get :show, id: video.id
      expect(assigns(:review)).to be_new_record
    end
  end

  describe "GET search" do
    it_behaves_like "require log in" do
      let(:action) { get :show, id: video.id }
    end

    before { set_current_user }

    it "sets the @search_phrase to the text being searched for if logged in" do
      get :search, search_term: 'breaking'
      expect(assigns(:search_phrase)).to eq('breaking')
    end

    it "sets the @search_result to the videos returned by the search if logged in" do
      vid1 = Fabricate(:video, title:'breaking bad')
      get :search, search_term: 'breaking'
      expect(assigns(:search_result)).to eq([vid1])
    end

    it "renders the serch result page if the user is logged in" do
      get :search, search_term: 'breaking'
      expect(response).to render_template :search 
    end
  end
end

