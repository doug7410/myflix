require 'spec_helper'

describe Category do 

  it { should have_many(:videos) }

  describe "recent_videos" do
    comedy = Category.create(name: 'Comedy')
    dramma = Category.create(name: 'Drama')
    let!(:vid1) { Video.create(title: 'Family Guy', description: 'a funny show', created_at: 7.days.ago, category: comedy) }
    let!(:vid2) { Video.create(title: 'Futurama', description: 'a funny show', created_at: 6.days.ago, category: comedy) }

    it "returns the videos in reverse cronological order by created at" do
      expect(comedy.recent_videos).to eq([vid2,vid1])
    end
    
    it "returns all the videos if less than 6 videos" do
      expect(comedy.recent_videos.count).to eq(2)
    end
    
    it "returns 6 videos if there are more than 6" do
      7.times { Video.create(title: 'Family Guy', description: 'a funny show', category: comedy) }
      expect(comedy.recent_videos.count).to eq(6)
    end
    
    it "returns array of the last six videos added to a category ordered by created at" do
      4.times { Video.create(title: 'Family Guy', description: 'a funny show', category: comedy) }
      monk = Video.create(title: 'Monk', description: 'a funny show', created_at: 10.days.ago, category: comedy)
      expect(comedy.recent_videos).not_to include(monk)
    end

    it "returns an empty arry if the category has no videos in it" do
      expect(dramma.recent_videos).to eq([])
    end 

  end

end

