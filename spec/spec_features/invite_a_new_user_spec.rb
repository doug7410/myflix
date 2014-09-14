require 'spec_helper'

feature 'a user logs in and invites a friend to join myflix' do
  scenario 'a user send out an invite and the invitation is accepted' do
    bob = Fabricate(:user)
    log_in_user(bob)
    invite_a_friend
    
    friend_acceptes_invitation
    friend_signs_in
    
    friend_should_follow(bob)      
    inviter_should_follow_friend(bob)    
    
    clear_emails
  end 

  private

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: 'Tom'
    fill_in "Friend's Email Address", with: 'tom@example.com'
    fill_in "Invitation Message", with: "Hi, come join Myflix!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_acceptes_invitation 
    open_email('tom@example.com')
    current_email.click_link 'Click here to join MyFlix'
    fill_in "Password", with: "Password"
    fill_in "Full Name", with: "Jean Claud"
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "Email", with: "tom@example.com"
    fill_in "Password", with: "Password"
    click_button "Sign In"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name    
    sign_out
  end

  def inviter_should_follow_friend(user)
    log_in_user(user)
    click_link "People"
    expect(page).to have_content "Jean Claud"
  end
end