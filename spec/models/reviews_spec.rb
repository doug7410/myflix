require 'spec_helper'

describe Review do
  it { should belong_to(:creator) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:rating) }

  #describe "average_rating" do
  #  it "returns the rating for each review on the current video" do
  #    monk = Fabricate(:video)
  #    bob = Fabricate(:user)
  #    review1 = Fabricate(:review)
  #    review2 = Fabricate(:review)
  #    expect(monk.reviews.average_rating).to match_array([review1.rating, review2.rating ])
  #  end
  #  it "calculates the average rating"
  #  it "rerturns string 'no ratings yet' if there are no reviews"
  #end
end

