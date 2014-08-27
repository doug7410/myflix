require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it_behaves_like "require log in" do
      let(:action) { get :index }
    end

    it "sets @relationships to all the relationships where the current user is the follower" do 
      bob = Fabricate(:user)
      set_current_user(bob)
      tom = Fabricate(:user)
      dan = Fabricate(:user)
      relationship1 = Fabricate(:relationship, follower: bob, leader: tom )
      relationship2 = Fabricate(:relationship, follower: bob, leader: dan )
      get :index
      expect(assigns(:relationships)).to eq([relationship1, relationship2]) 
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require log in" do
      let(:action) { delete :destroy, id: 4 }
    end

    let(:tom) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    before do
      set_current_user(bob)
    end

    it "deletes a relationship if the current user is the follower" do
      relationship = Fabricate(:relationship, follower: bob, leader: tom )
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0) 
    end

    it "redirects to the people index page" do
      relationship = Fabricate(:relationship, follower: bob, leader: tom )
      get :destroy, id: relationship.id
      expect(response).to redirect_to people_path 
    end

    it "does not delete the relationship if the current user is not the follower" do
      relationship = Fabricate(:relationship, follower: Fabricate(:user), leader: tom )
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end

    it "sets the flash message" do
      relationship = Fabricate(:relationship, follower: bob, leader: tom )
      delete :destroy, id: relationship.id
      expect(flash[:success]).not_to be_nil
    end
  end
end