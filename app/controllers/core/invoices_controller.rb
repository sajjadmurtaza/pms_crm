class Core::InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  def index
    @page_title = 'Invoices'

    @search = ESSearch.new
    @search.klass = Core::Invoice
    @search.init_params params
    @search.load_records = false
    @invoices = @search.search.records
  end

  def new
    @invoice = Core::Invoice.new(lead_id: params[:lead_id], project_id: params[:project_id], task_list_id: params[:task_list_id])
  end

  def edit
  end

  def create
    @invoice = Core::Invoice.new(invoice_params)
    @invoice.user = current_user
    @invoice.save
  end

  def update
    @invoice.update(invoice_params)
  end

  def show
    @page_title = @invoice.project.present? ? @invoice.project.title : @invoice.lead.name
  end

  def destroy
    @invoice.destroy
  end

  def self.default_view
    'table'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Core::Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:core_invoice).permit(:due_date, :organization_unit_id, :invoice_project, :invoice_task, :cost, :split_type_id, :status_id, :reference_id, :reference_type, :lead_id, :project_id, :task_list_id)
    end
end
