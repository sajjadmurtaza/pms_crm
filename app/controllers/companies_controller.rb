class CompaniesController < ApplicationController
    before_action :set_company, only: [:edit, :update, :show,:destroy]
    def index
      unless params[:companies].present?
        @company = Company.all
      else
        @company = Company.search(params[:companies][:search])
      end
    end

    def new
      @company = Company.new
      @uploader = AvatarUploader.new

    end


    def create
      @company = Company.new(company_attributes)
      if @company.save
        flash[:notice] = "Company is created Successfully."
        redirect_to companies_path
      else
        render :action => 'new'
      end
    end

    def update
      if @company.update_attributes(company_attributes)
        flash[:notice] = "Company is updated Successfully."
        redirect_to companies_path
      else
        render :action => 'edit'
      end
    end

    def destroy
      @company.destroy
      redirect_to companies_url
    end

    def set_company
      @company = Company.find(params[:id]) rescue nil
      redirect_to companies_path if @company.blank?
    end

    private
    def company_attributes
      params.require(:company)
      .permit(
          :title, :industry, :website,
          attachments_attributes: [:id, :name, :_destroy],
          emails_attributes: [:id, :email, :email_type, :_destroy],
          phones_attributes: [:id, :phone, :phone_type, :_destroy],
          addresses_attributes: [:id, :address1,:address2, :address_type, :city, :zip, :state, :country, :_destroy]
      )
    end

end
