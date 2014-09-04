require 'spec_helper'

describe User do 
  it { should have_many(:queue_items).order("list_order ASC")}
  it { should have_many(:reviews).order("created_at DESC")}

  describe "has_video_in_queue?" do
    it "returns true if the video is in the current user queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video) 
      expect(user.video_is_in_queue?(video)).to eq(true)
    end
    it "returns nill if the video is not in the current user queue" do
      user = Fabricate(:user)
      video = Fabricate(:video) 
      expect(user.video_is_in_queue?(video)).to be_nil
    end
  end

  describe "#folows?" do
    it "returns true if the folowing user is allready following the other user" do
      bob = Fabricate(:user)
      tom = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: tom)
      expect(bob.follows?(tom)).to eq(true)
    end

    it "returns false of the user is not following the other user" do
      bob = Fabricate(:user)
      tom = Fabricate(:user)
      expect(bob.follows?(tom)).to eq(false) 
    end
  end

  describe "generate_token" do
    it "generates a token for the user" do
      bob = Fabricate(:user)
      bob.generate_token
      expect(bob.token).not_to be_nil
    end

    it "generates a created_at timestamp for the token" do
      bob = Fabricate(:user)
      bob.generate_token
      expect(bob.token_created_at).not_to be_nil
    end 
  end
end
