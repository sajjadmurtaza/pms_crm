class SendEmailAction
  def initialize(params)
    @subject = params[:subject]
    @to = params[:to]
    @body = params[:body]
  end

  def perform
    puts "%%%%%% SEND EMAIL %%%%%%%%"
    puts "SUBJECT: #{@subject}"
    puts "TO: #{@to}"
    puts "BODY: #{@body}"
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%"
    NotificationsMailer.standard(@to,@subject,@body).deliver
  end
end