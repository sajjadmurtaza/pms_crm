class Core::SkillsController < ApplicationController
  before_action :set_core_skill, only: [:show, :edit, :update, :destroy]

  # GET /core/skills
  def index
    @page_title = 'Skills'
    add_breadcrumb 'Directory'
    add_breadcrumb 'Skills', skills_path
    @skills = Core::Skill.all.order(:skill_type_id)
    respond_to do |format|
      format.html
      format.json  { render json: @skills }
    end
  end

  # GET /core/skills/1
  def show
  end

  # GET /core/skills/new
  def new
    @page_title = 'Skills'
    add_breadcrumb 'Skills', skills_path
    add_breadcrumb 'New Skill'
    @skill = Core::Skill.new
  end

  # GET /core/skills/1/edit
  def edit
    @page_title = 'Skills'
    add_breadcrumb 'Skills', skills_path
    add_breadcrumb "Edit #{@skill.name}"
  end

  # POST /core/skills
  def create
    @skill = Core::Skill.new(core_skill_params)
    @skill.save
  end

  # PATCH/PUT /core/skills/1
  def update
    @skill.update_attributes(core_skill_params)
  end

  # DELETE /core/skills/1
  def destroy
    @skill.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_skill
      @skill = Core::Skill.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def core_skill_params
      params.require(:core_skill).permit(:name, :skill_type_id)
    end
end
