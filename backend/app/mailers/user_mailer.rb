class UserMailer < ApplicationMailer

  def registration_email(user, email_verification_number)
    @user = user
    @email_verification_number = email_verification_number
    mail(to: @user.email, subject: "メールアドレスの確認")
  end

end
