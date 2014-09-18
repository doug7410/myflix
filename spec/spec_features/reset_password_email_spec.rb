require 'spec_helper'

feature 'user resets password' do
  scenario 'the user request a reset password email and resets their password' do
    bob = Fabricate(:user, password: 'old_password')
    visit sessions_new_path
    click_link 'Forgot your password?' 
    fill_in 'email', with: bob.email
    click_button "Send Email"
    
    open_email(bob.email)
    current_email.click_link 'Reset your password here'
    
    fill_in 'password', with: 'new_password'
    click_button "Reset Password"
    
    fill_in "Email", with: bob.email
    fill_in "Password", with: 'new_password'
    click_button "Sign In"
    expect(current_path).to eq(home_path)
  end
end

