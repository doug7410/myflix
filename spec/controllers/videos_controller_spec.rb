require 'spec_helper'

describe VideosController do
  let(:user) {Fabricate(:user)}
  let(:video) {Fabricate(:video)}
  
  describe "GET show" do
    it "sets the requested video to @video" do
      session[:user_id] = user.id
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "renders the show template if the user is logged in" do
      session[:user_id] = user.id
      get :show, id: video.id
      expect(response).to render_template :show
    end

    it "redirects to the site root if the user is not logged in" do
      session[:user_id] = nil
      get :show, id: video.id
      expect(response).to redirect_to root_path
    end
  end

  describe "GET search" do
    it "redirects the use the site root if the use is not logged in" do
      session[:user_id] = nil
      get :search, search_term: 'breaking'
      expect(response).to redirect_to root_path
    end

    it "sets the @search_phrase to the text being searched for if logged in" do
      session[:user_id] = user.id
      get :search, search_term: 'breaking'
      expect(assigns(:search_phrase)).to eq('breaking')
    end

    it "sets the @search_result to the videos returned by the search if logged in" do
      vid1 = Video.create(title: "breaking bad", description: "A good show.")
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

