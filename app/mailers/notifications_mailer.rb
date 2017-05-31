class NotificationsMailer < ActionMailer::Base
  default from: Core::Setting.mail_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.standard.subject
  #
  def standard(to, subject, mail_body)
    @mail_body = mail_body
    mail to: to, subject: subject, from: Core::Setting.mail_from
  end
end
