class Core::QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  # GET /core/quotes
  # GET /core/quotes.json
  # def index
  #   @quotes = Core::Quote.all
  # end

  # GET /core/quotes/1
  # GET /core/quotes/1.json
  def show
    @page_title = @quote.project.present? ? @quote.project.title : @quote.lead.name
  end

  # GET /core/quotes/new
  def new
    @quote = Core::Quote.new(lead_id: params[:lead_id], project_id: params[:project_id])
  end

  # GET /core/quotes/1/edit
  def edit
  end

  # POST /core/quotes
  # POST /core/quotes.json
  def create
    @quote = Core::Quote.new(quote_params)
    @quote.save
  end

  # PATCH/PUT /core/quotes/1
  # PATCH/PUT /core/quotes/1.json
  def update
    @quote.update(quote_params)
  end

  # DELETE /core/quotes/1
  # DELETE /core/quotes/1.json
  def destroy
    @quote.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Core::Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.require(:core_quote).permit(:amount, :description, :invoice_split_id, :quote_date, :project_id, :lead_id, :reference_id, :reference_type, :status_id,
                                         attachments_attributes: [:id, :name, :_destroy],)
    end
end
