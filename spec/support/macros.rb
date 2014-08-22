def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user).id)
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def log_in_user(user=nil)
  logged_in_user = user || Fabricate(:user)
  visit sessions_new_path
  fill_in "Email", with: logged_in_user.email
  fill_in "Password", with: logged_in_user.password
  click_button "Sign In"
end