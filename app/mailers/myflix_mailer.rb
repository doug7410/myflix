class MyflixMailer < ActionMailer::Base

  def welcome_user_email(user)
    @user = user
    mail from: 'd.steinberg@gmail.com', to: user.email, subject: "Welcome to Myflix!" 
  end

  def send_password_reset(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "MyFlix: reset your password"
  end
end