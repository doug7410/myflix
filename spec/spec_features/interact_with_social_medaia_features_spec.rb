require 'spec_helper'

feature "user interacts with social media features"  do
  
  given(:bob) { Fabricate(:user) }
  given(:tom) { Fabricate(:user) }
  given(:comedies) { Fabricate(:category) }
  given(:the_office) { Fabricate(:video, category: comedies) }
  given!(:review) { Fabricate(:review, user: tom, video: the_office) }

  scenario "follow and unfollow a user" do
    log_in_user(bob)
    click_a_video_on_the_home_page(the_office)
    click_on_a_review_author(tom)
    expect_to_be_on_the_users_page(tom)
    follow_a_user(tom)
    expect_the_user_to_be_on_people_page(tom)
    un_follow_a_user(tom)
    expect_a_user_not_to_be_on_people_page(tom)
  end
end

def expect_a_user_not_to_be_on_people_page(user)
  expect(page).not_to have_link(user.full_name)
end

def un_follow_a_user(user)
  find("a[href='/relationships/#{user.id}']").click
end

def  expect_the_user_to_be_on_people_page(user)
  visit people_path
  expect(page).to have_link(user.full_name)
end

def follow_a_user(user)
  find("a[href='/follow_person/#{user.id}']").click
end

def expect_to_be_on_the_users_page(user)  
  expect(current_path).to eq(user_path(user)) 
end

def click_on_a_review_author(user)
  click_link user.full_name
end