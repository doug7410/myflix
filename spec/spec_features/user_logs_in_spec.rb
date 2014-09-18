require 'spec_helper'

feature 'User logs in' do
  scenario "with valid email and password" do
    bob = Fabricate(:user)
    visit sessions_new_path
    fill_in "Email", with: bob.email
    fill_in "Password", with: bob.password
    click_button "Sign In"
    expect(page).to have_content bob.full_name
  end
end 
