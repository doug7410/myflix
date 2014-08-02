require 'spec_helper'

describe User do 
  it { should have_many(:queue_items).order("list_order ASC")}

  describe "video_rating" do
    it "returns the last rating given to the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video, user: user)
      review2 = Fabricate(:review, video: video, user: user)
      expect(user.video_rating(video)).to eq(review2.rating)
    end

    it "returns nil if the user hasn't given the video a rating" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.video_rating(video)).to be_nil
    end
  end
end