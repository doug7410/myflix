require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require log in" do
      let(:action) { get :new }
    end
    
    it_behaves_like "requires admin" do
      let(:action) {get :new}
    end 

    it "sets the new @video if the user is an admin" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end 

    it "sets the flash message if the user is not an admin" do
      set_current_user
      get :new  
      expect(flash[:warning]).not_to be_nil
    end
  end

  describe "POST create" do  
    it_behaves_like "require log in" do
      let(:action) {post :create}
    end

    it_behaves_like "requires admin" do
      let(:action) {post :create}
    end

    context "with valid input" do
      it "redirects to the add new video page" do
        set_current_admin
        dramas = Fabricate(:category)
        post :create, video: {title: "Twentyfour", category_id: dramas.id, description: "awesome show!"}
        expect(response).to redirect_to new_admin_video_path
      end
      
      it "creates a new video" do
        set_current_admin
        dramas = Fabricate(:category)
        post :create, video: {title: "Twentyfour", category_id: dramas.id, description: "awesome show!"}
        expect(Video.count).to eq(1) 
      end 

      it "sets the flash success message" do
        set_current_admin
        dramas = Fabricate(:category)
        post :create, video: {title: "Twentyfour", category_id: dramas.id, description: "awesome show!"}
        expect(flash[:success]).not_to be_nil
      end 
    end

    context "with invalid input" do
      it "does not create a video" do
        set_current_admin
        post :create, video: {title: "Twentyfour"}
        expect(Video.count).to eq(0)
      end
      it "renders the :new template" do 
        set_current_admin
        post :create, video: {title: "Twentyfour"}
        expect(response).to render_template :new
      end
      it "sets the @video variable" do
        set_current_admin
        post :create, video: {title: "Twentyfour"}
        expect(assigns(:video)).to be_a_new_record
        expect(assigns(:video)).to be_instance_of(Video)
      end
      it "sets the flash error message" do
        set_current_admin
        post :create, video: {title: "Twentyfour"}
        expect(flash[:warning]).not_to be_nil
      end
    end
  end 

  describe "GET show" do
    let(:south_park) { Fabricate(:video) }

    it_behaves_like "require log in" do
      let(:action) {get :show, id: south_park.id}
    end

    it_behaves_like "requires admin" do
      let(:action) {get :show, id: south_park.id}
    end

    it "renders the show template" do
      set_current_admin
      get :show, id: south_park.id
      expect(response).to render_template :show
    end

    it "sets the @video" do
      set_current_admin
      get :show, id: south_park.id
      expect(assigns(:video)).to eq(south_park)
    end 

  end

  describe "PATCH update" do
    let(:south_park) { Fabricate(:video) }

    it_behaves_like "require log in" do
      let(:action) {patch :update, id: south_park.id}
    end

    it_behaves_like "requires admin" do
      let(:action) {patch :update, id: south_park.id}
    end

    context "with valid input" do
      it "redirects to the video show page" do
        set_current_admin
        patch :update, id: south_park.id, video: Fabricate.attributes_for(:video)
        expect(response).to redirect_to admin_video_path(south_park)
      end

      it "sets the flash success message" do
        set_current_admin
        patch :update, id: south_park.id, video: Fabricate.attributes_for(:video)
        expect(flash[:success]).to be_present
      end
      it "updates the video" do
        set_current_admin
        patch :update, id: south_park.id, video: {title: "Futurama", description: south_park.description}
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "sets the @video" do
        set_current_admin
        patch :update, id: south_park.id, video: {title: "", description: south_park.description}
        expect(assigns(:video)).to eq(south_park)
      end

      it "sets the flash error message" do
        set_current_admin
        patch :update, id: south_park.id, video: {title: "", description: south_park.description}
        expect(flash[:danger]).to be_present
      end

      it "renders the show template" do
        set_current_admin
        patch :update, id: south_park.id, video: {title: "", description: south_park.description}
        expect(response).to render_template :show
      end  
    end
  end
end