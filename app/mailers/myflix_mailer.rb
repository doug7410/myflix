class MyflixMailer < ActionMailer::Base

  def welcome_user_email(user)
    @user = user
    mail from: 'd.steinberg@gmail.com', to: user.email, subject: "Welcome to Myflix!" 
  end
end