class Directory::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  
  def index
    @page_title = 'Employees'
    add_breadcrumb 'Directory', users_path
    add_breadcrumb 'Employees', users_path
    @search = ESSearch.new
    @search.klass = Directory::User
    @search.init_params params
    @search.load_records = false
    @users = @search.search.records
  end

  def edit
    @page_title = @user.name
    add_breadcrumb 'Directory', users_path
    add_breadcrumb 'Employees', users_path
    load_association
  end

  def new
    @page_title = 'Employee'
    add_breadcrumb 'Directory', users_path
    add_breadcrumb 'Employees', users_path
    add_breadcrumb 'New Employee'
    @user = Directory::User.new
    @user.build_user_detail
    load_association
  end

  def create
    @user = Directory::User.new
    @user.build_user_detail
    @user.assign_attributes(user_params)

    if @user.save
      @user.set_default_picture unless @user.picture.present?
      flash[:notice] = "Successfully created User"
      redirect_to user_path(@user)
    else
      @page_title = 'Employee'
      add_breadcrumb 'Directory', users_path
      add_breadcrumb 'Employees', users_path
      add_breadcrumb 'New Employee'
      load_association
      render :action => 'new'
    end
  end

  def update
    @user.assign_attributes(user_params)
    if @user.first_name_changed? or @user.last_name_changed?
      unless @user.picture.name_changed?
        @user.set_default_picture
      end
    end
    if @user.save
      redirect_to user_path(@user)
    else
      @page_title = @user.name
      add_breadcrumb 'Directory', users_path
      add_breadcrumb 'Employees', users_path
      load_association
      flash[:message] = 'Profile is not updated.'
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:notice]="User Deleted Successfully"
    redirect_to users_path
  end

  def show
    @page_title = @user.name
    add_breadcrumb 'Directory', users_path
    add_breadcrumb 'Employees', users_path
    unless @user.user_detail.present?
      @user.build_user_detail
      @user.save(validate: false)
    end
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: @user.name,
               template: 'directory/users/show.pdf.slim',
               layout: 'pdf.html.slim',
                   margin: {top: 0,
                           bottom: 0,
                           left: 0,
                           right: 0},
               outline: {outline: true,
                            outline_depth: 2}
       end
    end
  end

  def load_association
    @user.emails.build unless @user.emails.present?
    @user.phones.build unless @user.phones.present?
    @user.addresses.build unless @user.addresses.present?
    @user.projects.build unless @user.projects.present?
    @user.build_picture unless @user.picture.present?
    unless @user.user_detail.present?
      @user.build_user_detail
      @user.save(validate: false)
    end
  end

  def set_user
    puts '##################################'
    puts params[:id]
    puts '##################################'
    @user = Directory::User.find(params[:id])
  end

  private

  def user_params
    params.require(:directory_user).permit(:username, :email, :time_zone, :theme,
      :old_password,:current_password, :password, :password_confirmation, :remember_me,
      :first_name, :last_name, :emp_id, :education, :experience, :primary_role_id, :secondary_roles, :job_title_id, :location_id, :calling_name,
      :perfered_development_environment, :the_most_amazing, :summery, :organization_unit_id,
      picture_attributes: [:id, :name, :_destroy],
      emails_attributes: [:id, :email, :email_type, :_destroy],
      phones_attributes: [:id, :phone, :phone_type, :_destroy],
      addresses_attributes: [:id, :address1,:address2, :address_type, :city, :zip, :state, :country, :_destroy],
      taggings_attributes: [:id, :tag_id, :taggable_id, :taggable_type, :tagger_id, :tagger_type, :rating, :context, :_destroy],
      skills_users_attributes: [:id, :rating, :experience, :show_on_profile, :skill_id, :_destroy],
      projects_attributes: [:id, :title, :description, :responsibilities, :url, :tools_and_tech, :portfolioable_id, :portfolioable_type, :tab, :_destroy]
    )
  end
end
