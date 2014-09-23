require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require log in" do
      let(:action) { get :new }
    end
    
    it "sets the new @video if the user is an admin" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end 
    
    it "redirects to the home page if the user is not an admin" do
      set_current_user
      get :new  
      expect(response).to redirect_to home_path
    end

    it "sets the flash message if the user is not an admin" do
      set_current_user
      get :new  
      expect(flash[:warning]).not_to be_nil
    end
  end 
end