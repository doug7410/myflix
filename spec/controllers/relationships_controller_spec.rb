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

    it "shows the number of followers for each person" do
      bob = Fabricate(:user)
      set_current_user(bob)
      tom = Fabricate(:user)
      dan = Fabricate(:user)
      relationship1 = Fabricate(:relationship, follower: bob, leader: dan )
      relationship2 = Fabricate(:relationship, follower: tom, leader: dan )
      get :index
      expect(dan.leading_relationships).to eq([relationship1, relationship2]) 
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require log in" do
      let(:action) { get :index }
    end

    let(:tom) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    before do
      set_current_user(bob)
    end

    it "redirects to the people index page" do
      relationship = Fabricate(:relationship, follower: bob, leader: tom )
      get :destroy, id: relationship.id
      expect(response).to redirect_to people_path 
    end

    it "deletes a relationship for the passed in user" do
      relationship = Fabricate(:relationship, follower: bob, leader: tom )
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0) 
    end

    it "does not delete the relationship if the current user is not the follower" do
      dan = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: dan, leader: tom )
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