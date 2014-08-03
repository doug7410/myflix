require 'spec_helper'

describe ApplicationController do
  describe "video_is_in_queue?" do
    it "returns true if the video is in the current user queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video) 
      expect(subject.video_is_in_queue?(video)).to eq(true)
    end
    it "returns nill if the video is not in the current user queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video) 
      expect(subject.video_is_in_queue?(video)).to be_nil
    end
  end
end