class Directory::AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /directory/accounts
  def index
    @page_title = 'Accounts'
    add_breadcrumb 'Directory', accounts_path
    add_breadcrumb 'Accounts', accounts_path
    @search = ESSearch.new
    @search.klass = Directory::Account
    @search.init_params params
    @search.load_records = false
    @accounts = @search.search.records
  end

  # GET /directory/accounts/1
  def show
    @page_title = @account.title
    add_breadcrumb 'Directory', accounts_path
    add_breadcrumb 'Accounts', accounts_path
  end

  # GET /directory/accounts/new
  def new
    @page_title = 'Accounts'
    add_breadcrumb 'Directory'
    add_breadcrumb 'Accounts', accounts_path
    add_breadcrumb 'New Account'
    @account = Directory::Account.new
    load_association
  end

  # GET /directory/accounts/1/edit
  def edit
    @page_title = @account.title
    add_breadcrumb 'Directory', accounts_path
    add_breadcrumb 'Accounts', accounts_path
  end

  # POST /directory/accounts
  def create
    @account = Directory::Account.new(directory_account_params)

    if @account.save
      redirect_to account_path(@account), notice: 'Account was successfully created.'
    else
      @page_title = 'Accounts'
      add_breadcrumb 'Directory'
      add_breadcrumb 'Accounts', accounts_path
      add_breadcrumb 'New Account'
      render :action => 'new'
    end
  end

  # PATCH/PUT /directory/accounts/1
  def update
    if @account.update(directory_account_params)
      redirect_to account_path(@account), notice: 'Account was successfully updated.'
    else
      @page_title = @account.title
      add_breadcrumb 'Directory', accounts_path
      add_breadcrumb 'Accounts', accounts_path
      render :action => 'edit'
    end
  end

  # DELETE /directory/accounts/1
  def destroy
    @account.destroy
    redirect_to accounts_path, notice: 'Account was successfully destroyed.'
  end

  def load_association
    @account.emails.build
    @account.billing_address.build
    @account.postal_address.build
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Directory::Account.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def directory_account_params
      params.require(:directory_account).permit(
          :account_number, :title,
          billing_address_attributes: [:id, :address1, :address2, :address_type, :city, :zip, :state, :country, :_destroy],
          postal_address_attributes: [:id, :address1, :address2, :address_type, :city, :zip, :state, :country, :_destroy],
          emails_attributes: [:id, :email, :email_type, :_destroy]
      )
    end
end
