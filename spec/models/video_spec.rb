require 'spec_helper'

describe Video do 
  
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it "finds no matches from search" do
    vid1 = Video.create(title: 'Family Guy', description: "a funny show")
    vid2 = Video.create(title: 'Futurame', description: "A funny show about the future.")
    expect(Video.search_by_title('monk')).to eq([])
  end

  it "finds exactly one match from search" do
    vid1 = Video.create(title: 'Family Guy', description: "a funny show")
    vid2 = Video.create(title: 'Futurama', description: "A funny show about the future.")
    expect(Video.search_by_title('Family').first).to eq(vid1)
  end

  it "finds multiple matches from search" do
    vid1 = Video.create(title: 'Family Guy', description: "a funny show")
    vid2 = Video.create(title: 'Futurama', description: "A funny show about the future.")
    expect(Video.search_by_title('f')).to eq([vid1,vid2])
  end
end 