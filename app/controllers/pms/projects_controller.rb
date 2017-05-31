class Pms::ProjectsController < ApplicationController

  def index
    @page_title = 'Projects'
    add_breadcrumb 'PMS', projects_path
    add_breadcrumb 'Projects', projects_path
    @search = ESSearch.new
    @search.klass = current_user.created_projects
    @search.init_params params
    @search.load_records = false
    @projects = @search.search.records
  end

  def new
    @page_title = 'Projects'
    add_breadcrumb 'PMS', projects_path
    add_breadcrumb 'Projects', projects_path
    add_breadcrumb 'New Project'
    @project = Pms::Project.new
    @project.projects_contacts.build unless @project.projects_contacts.present?
    @project.projects_users.build unless @project.projects_users.present?
  end

  def create
    @project = Pms::Project.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to project_path(@project)
    else
      @page_title = 'Projects'
      add_breadcrumb 'PMS', projects_path
      add_breadcrumb 'Projects', projects_path
      add_breadcrumb 'New Project'
      render :new
    end
  end

  def edit
    @project = Pms::Project.find(params[:id])
    @page_title = @project.try(:title)
    add_breadcrumb 'PMS', projects_path
    add_breadcrumb 'Projects', projects_path
    @project.projects_contacts.build unless @project.projects_contacts.present?
    @project.projects_users.build unless @project.projects_users.present?
  end

  def update
    @project = Pms::Project.find(params[:id])
    if @project.update_attributes(project_params)
      redirect_to project_path(@project)
    else
      @page_title = @project.try(:title)
      add_breadcrumb 'PMS', projects_path
      add_breadcrumb 'Projects', projects_path
      render :edit
    end
  end

  def show
    @project = Pms::Project.find(params[:id])
    @page_title = @project.title
    @metadata = @project.try(:status)
    @invoices = Core::Invoice.where("project_id = ? or lead_id = ?", @project.id, @project.try(:lead).try(:id))
    @quotes = Core::Quote.where("project_id = ? or lead_id = ?", @project.id, @project.try(:lead).try(:id))
  end

  def destroy
    @project = Pms::Project.find(params[:id])
    @project.destroy
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:pms_project)
    .permit(
        :title, :description, :start_date, :end_date, :account_id, :manager_id, :lead_id, :status_id, :percentage_done, :planned_end_date, :cost,
        projects_users_attributes: [:id, :user_id, :_destroy],
        projects_contacts_attributes: [:id, :contact_id, :_destroy],
        attachments_attributes: [:id, :name, :_destroy]
    )
  end
end
