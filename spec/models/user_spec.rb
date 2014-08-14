require 'spec_helper'

describe User do 
  it { should have_many(:queue_items).order("list_order ASC")}

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
end