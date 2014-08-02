require 'spec_helper'

describe QueueItem do
  it { should belong_to(:video) }
  it { should belong_to(:user) }

  describe "#video_title" do
    it "returns the name of the video for the queue item" do
      video = Fabricate(:video, title: "Breaking Bad")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Breaking Bad")
    end
  end

  describe "rating" do
    it "returns the last rating given to the video by the user" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video, user: user, rating: 5)
      review2 = Fabricate(:review, video: video, user: user, rating: 3)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if the user hasn't given the video a review" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#category_name" do
    it "returns the category name of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      review = Fabricate(:review, video: video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq(category.name)
    end
  end

  describe "category" do
    it "returns the category object of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end

end
