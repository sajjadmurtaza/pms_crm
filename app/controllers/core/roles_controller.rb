class Core::RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /core/roles
  # GET /core/roles.json
  def index
    @page_title = 'Roles'
    @roles = Core::Role.all
  end

  # GET /core/roles/1
  # GET /core/roles/1.json
  def show
  end

  # GET /core/roles/new
  def new
    @role = Core::Role.new
  end

  # GET /core/roles/1/edit
  def edit
  end

  # POST /core/roles
  # POST /core/roles.json
  def create
    @role = Core::Role.new(role_params)
    @role.save
  end

  # PATCH/PUT /core/roles/1
  # PATCH/PUT /core/roles/1.json
  def update
      @role.update(role_params)
  end

  # DELETE /core/roles/1
  # DELETE /core/roles/1.json
  def destroy
    @role.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Core::Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:core_role).permit(:name, :description)
    end
end
