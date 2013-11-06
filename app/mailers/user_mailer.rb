class UserMailer < ActionMailer::Base
  default from: 'puxuanhe@gmail.com'
 
  def password_email(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email, subject: 'New Password From Ceraigslist')
  end
end