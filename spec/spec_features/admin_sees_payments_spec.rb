require 'spec_helper'

feature "Admin sees payments" do
  background do
    bob = Fabricate(:user, full_name: "Bob Burger", email: "bob@bob.com")
    Fabricate(:payment, ammount_in_cents: 999, user: bob)
  end

  scenario "admin can see payments" do
    log_in_user(Fabricate(:admin))
    visit admin_payments_path 
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Bob Burger")
    expect(page).to have_content("bob@bob.com")
  end

  scenario "user can not see payments" do
    log_in_user(Fabricate(:user))
    visit admin_payments_path 
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Bob Burger")
    expect(page).not_to have_content("bob@bob.com")
    expect(page).to have_content("That page is only accessible by admistrators.")
  end 
end