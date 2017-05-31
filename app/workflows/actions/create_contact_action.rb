class CreateContactAction
  def initialize(params)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @username = params[:username]
    @email = params[:email]

  end

  def perform
    @contact = Directory::Contact.new
    @contact.build_contact_detail
    @contact.first_name = @first_name
    @contact.last_name = @last_name
    @contact.username = @username
    @contact.email = @email

    @contact.save
  end

end