class Admin::OrganizationUnitsController < Admin::BaseController
  before_action :set_organization_unit, only: [:show, :edit, :update, :destroy]

  # GET /organization_units
  def index
    @page_title = 'Organization Units'
    @organization_units = Core::OrganizationUnit.all
    @organization_units << Core::OrganizationUnit.create!(title:'Organization', role: 'Sample/Role') if @organization_units.empty?
    respond_to do |format|
      format.html
      format.json { render :json => {:tree_data =>  Core::OrganizationUnit.sort_by_ancestry(@organization_units).as_json,:dropdown_data =>  Core::OrganizationUnit.sort_by_ancestry(@organization_units).as_json({:tree=>false})} }
    end
  end

  def show
  end

  # GET /organization_units/new
  def new
    @organization_unit = Core::OrganizationUnit.new
  end

  # GET /organization_units/1/edit
  def edit
  end

  # POST /organization_units
  def create
    @organization_unit = Core::OrganizationUnit.find_by_id(params[:parent_id])
    if @organization_unit
      @new_organization_unit = @organization_unit.children.create title: params[:title], role: params[:role]
      render nothing: true
    else
      render nothing: true
    end
  end

  # PATCH/PUT /organization_units/1
  def update
    @desired_parent = Core::OrganizationUnit.find(params[:parent_id]) if params[:parent_id] != 'null'
    @organization_unit = Core::OrganizationUnit.find(params[:id])
    if @desired_parent.present?
      if @desired_parent.parent == @organization_unit
        parent_ancestry = @desired_parent.ancestry
        child_ancestry = @organization_unit.ancestry
        @desired_parent.update_attribute :ancestry, child_ancestry
        @organization_unit.update_attribute :ancestry, parent_ancestry.gsub(@organization_unit.id.to_s, @desired_parent.id.to_s)
        render nothing: true
      else
        @organization_unit.update_attributes :title => params[:title],:role => params[:role], :parent => @desired_parent
        render nothing: true
      end
    else
      @organization_unit.update_attributes :title => params[:title], :role => params[:role]
      render nothing: true
    end
  end

  # DELETE /organization_units/1
  def destroy
    @organization_unit = Core::OrganizationUnit.find(params[:node_id])
    @organization_unit.destroy
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_unit
      @organization_unit =Core::OrganizationUnit.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def organization_unit_params
      params.require(:core_organization_unit).permit(:title,:role,:ancestry,:path,:parent_id,:node_id)
    end

end
