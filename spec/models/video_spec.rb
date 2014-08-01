require 'spec_helper'

describe Video do 
  
  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search by title" do
    
    let!(:vid1) { Video.create(title: 'Family Guy', description: 'a funny show', created_at: 1.day.ago) }
    let!(:vid2) { Video.create(title: 'Futurama', description: "A funny show about the future." )}

    it "returns an empty array in there is no match" do
      expect(Video.search_by_title('monk')).to eq([])
    end

    it "returns an array of one video for an exact match" do
      expect(Video.search_by_title('Family').first).to eq(vid1)
    end

    it "returns and array of one video for a partial match" do 
      expect(Video.search_by_title('mily').first).to eq(vid1)
    end

    it "returns am array of all matches ordered by created at" do
      expect(Video.search_by_title('f')).to eq([vid2,vid1])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Video.search_by_title('')).to eq([])
    end
  end

  describe "average_rating" do
    it "returns the average of all the ratings if the video has reviews" do
      video = Fabricate(:video)
      Fabricate(:review, rating: 4, video: video, creator: Fabricate(:user)) 
      Fabricate(:review, rating: 1, video: video, creator: Fabricate(:user)) 
      Fabricate(:review, rating: 2, video: video, creator: Fabricate(:user)) 
      expect(video.average_rating).to eq(2.33)
    end
   
    it "returns nil if the video has no reviews" do 
      video = Fabricate(:video)
      expect(video.average_rating).to be_nil
    end
  end
end 