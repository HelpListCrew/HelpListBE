class SendWelcomeEmailJob
  include Sidekiq::Job

  def perform(email, welcome)
    UserNotifierMailer.send_welcome_email(email, welcome).deliver_now
  end
end
