class UserNotifierMailer < ApplicationMailer
  def send_welcome_email(email, welcome)
    @email = email
    mail(to: @email, subject: welcome)
  end

end