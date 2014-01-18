class NotificationMailer < ActionMailer::Base
  default from: "noreply@cakeside.com"

  def notification_email(activity)
    @user = activity.user
    @activity = activity
   mail(to: @user.email, subject: "New Activity on CakeSide")
  end
end
