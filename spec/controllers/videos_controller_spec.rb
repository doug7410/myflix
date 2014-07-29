require 'spec_helper'

describe VideosController do
  let(:user) {Fabricate(:user)}
  let(:video) {Fabricate(:video)}
  
  describe "GET show" do
    context "with authenticated users" do
      before do
        session[:user_id] = user.id
      end

      it "sets the requested video to @video" do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the login page if the user is not logged in" do
        get :show, id: video.id
        expect(response).to redirect_to sessions_new_path
      end
    end
  end

  describe "GET search" do
    it "redirects the use the login page if the use is not logged in" do
      session[:user_id] = nil
      get :search, search_term: 'breaking'
      expect(response).to redirect_to sessions_new_path
    end

    it "sets the @search_phrase to the text being searched for if logged in" do
      session[:user_id] = user.id
      get :search, search_term: 'breaking'
      expect(assigns(:search_phrase)).to eq('breaking')
    end

    it "sets the @search_result to the videos returned by the search if logged in" do
      vid1 = Fabricate(:video, title:'breaking bad')
      session[:user_id] = user.id
      get :search, search_term: 'breaking'
      expect(assigns(:search_result)).to eq([vid1])
    end

    it "renders the serch result page if the user is logged in" do
      session[:user_id] = user.id
      get :search, search_term: 'breaking'
      expect(response).to render_template :search 
    end
  end
end

