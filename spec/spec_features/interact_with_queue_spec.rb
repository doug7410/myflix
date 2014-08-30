require 'spec_helper'     

feature 'User interacts with queue' do

  given(:bob) { Fabricate(:user) }
  given(:comedies) { Fabricate(:category) }
  given!(:the_office) { Fabricate(:video, category: comedies) }
  given!(:portlandia) { Fabricate(:video, category: comedies) }
  given!(:parks_and_reck) { Fabricate(:video, category: comedies) }

  scenario "add videos to queue and re-order them" do
    log_in_user(bob)
    click_video_and_add_to_queue(the_office)
    expect_queue_page_to_have_video(the_office)
    
    click_video_and_add_to_queue(portlandia)
    click_video_and_add_to_queue(parks_and_reck)
    expect_queue_page_to_have_video(portlandia)
    expect_queue_page_to_have_video(parks_and_reck)

    fill_in_list_order(the_office, 3)
    fill_in_list_order(portlandia, 1)
    fill_in_list_order(parks_and_reck, 2)

    click_button 'Update Instant Queue'
    
    expect_video_list_order(portlandia, 1)
    expect_video_list_order(parks_and_reck, 2)
    expect_video_list_order(the_office, 3)
  end
end

def expect_video_list_order(video, list_order)
  expect(find(:xpath, "//tr[contains(., '#{video.title}')]//input[@name='queue_items[][list_order]']").value).to eq(list_order.to_s)
end

def fill_in_list_order(video, list_order)
  within(:xpath, "//tr[contains(., '#{video.title}')]") do
    fill_in 'queue_items[][list_order]', :with => list_order.to_s
  end
end

def expect_queue_page_to_have_video(video)
    expect(current_path).to eq(my_queue_path)
    expect(page).to have_xpath("//tr[contains(., '#{video.title}')]")
end

def click_video_and_add_to_queue(video)
  click_a_video_on_the_home_page(video)
  click_link "+ My Queue" 
end