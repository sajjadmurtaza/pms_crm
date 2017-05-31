class TaskListsWidget < Apotomo::Widget
  include ApplicationHelper
  include SemanticIconHelper

  helper_method :semantic_icon
  helper_method :current_user


  responds_to_event :new
  responds_to_event :create
  responds_to_event :edit
  responds_to_event :update
  responds_to_event :search
  responds_to_event :destroy
  responds_to_event :cancel
  responds_to_event :new_task
  responds_to_event :create_task
  responds_to_event :edit_task
  responds_to_event :update_task
  responds_to_event :delete_task
  responds_to_event :switch_task_completion
  responds_to_event :show_task

  def display(event)
    @object = event[:taskable]

    render
  end

  def new(event)
    @task_list = Pms::TaskList.new
    @object = params[:taskable_type].constantize.find(params[:taskable_id])
    @task_list.taskable = @object

    render
  end

  def create
    @task_list = Pms::TaskList.new(task_list_params)
    @task_list.save
    @object = @task_list.taskable
    @task = Pms::Task.new
    @task.task_list = @task_list

    render
  end

  def edit
    @task_list = Pms::TaskList.find(params[:id])

    render
  end

  def update
    @task_list = Pms::TaskList.find(params[:pms_task_list][:id])
    @task_list.update_attributes(task_list_params)
    @object = @task_list.taskable

    replace :view => :display
  end

  def destroy
    @task_list = Pms::TaskList.find(params[:id])
    @object = @task_list.taskable
    @task_list.destroy

    replace :view => :display
  end

  def cancel
    @task_list = Pms::TaskList.find(params[:id])
    @object = @task_list.taskable

    replace :view => :display
  end

  def new_task
    @task_list = Pms::TaskList.find(params[:id])
    @task = Pms::Task.new
    @task.attachments.build unless @task.attachments.present?
    @task.task_list = @task_list

    render
  end

  def create_task
    @task = Pms::Task.new(task_params)
    @task.user = current_user
    @task.save
    @created_task = @task
    @task_list = @task.task_list
    @object = @task_list.taskable
    @task = Pms::Task.new
    @task.task_list = @task_list

    render
  end

  def edit_task
    @task = Pms::Task.find(params[:task_id])
    @task_list = @task.task_list

    render
  end

  def update_task
    @task = Pms::Task.find(params[:pms_task][:id])
    @task.update_attributes(task_params)
    @task_list = @task.task_list
    @object = @task_list.taskable

    replace :view => :display
  end

  def delete_task
    @task = Pms::Task.find(params[:task_id])
    @task_list = @task.task_list
    @task.destroy
    @object = @task_list.taskable

    replace :view => :display
  end

  def switch_task_completion
    @task = Pms::Task.find(params[:task_id])
    @task.update_attribute(:completed, !@task.completed)
    @task_list = @task.task_list
    @object = @task_list.taskable

    replace :view => :display
  end

  def show_task
    @task = Pms::Task.find(params[:task_id])

    render
  end

  private
  def task_list_params
    params.require(:pms_task_list)
        .permit(
            :title, :description, :project_id, :taskable_id, :taskable_type, :billable
        )
  end

  def task_params
    params.require(:pms_task)
        .permit(
            :due_date, :task_list_id, :description, tasks_users_attributes: [:id, :user_id, :_destroy],
            attachments_attributes: [:id, :name, :_destroy]
        )
  end

end
