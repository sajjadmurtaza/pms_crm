class CreateAccountAction
  def initialize(params)
    @title = params[:title]
    @account_number = params[:account_number]
    @email = params[:email]
  end

  def perform
    @account = Directory::Account.new
    @account.title = @title
    @account.account_number = @account_number
    @account.email = @email

    @account.save
  end

end