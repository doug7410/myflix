def set_current_user
  john = Fabricate(:user)
  session[:user_id] = john.id
end

def current_user
  User.find(session[:user_id])
end

def video
  Fabricate(:video)
end