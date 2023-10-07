class UserMailer < ApplicationMailer

  def registration_email(user, email_verification_number)
    @user = user
    @email_verification_number = email_verification_number
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

end
