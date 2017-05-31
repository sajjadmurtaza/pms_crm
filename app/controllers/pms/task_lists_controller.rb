class Pms::TaskListsController < ApplicationController
  before_action :set_task_lisk, only: [:edit, :update, :destroy, :cancel, :add_task, :show]

  def new
    @task_list = Pms::TaskList.new
    @project = Pms::Project.find(params[:project_id])
    @task_list.taskable = @project
  end

  def create
    @task_list = Pms::TaskList.new(task_list_params)
    @task_list.save
    @project = @task_list.taskable
  end

  def edit
  end

  def update
    @task_list.update_attributes(task_list_params)
    @project = @task_list.taskable
  end

  def destroy
    @project = @task_list.taskable
    @task_list.destroy
  end

  def cancel
    @project = @task_list.taskable
  end

  def show
  end

  def add_task
    @task = Pms::Task.new
    @task.task_list = @task_list
  end

  def create_task
    @task = Pms::Task.new(task_params)
    @task.user = current_user
    @task.save
    @task_list = @task.task_list
    get_tasks
  end

  def edit_task
    @task = Pms::Task.find(params[:task_id])
    @task_list = @task.task_list
  end

  def update_task
    @task = Pms::Task.find(params[:pms_task][:id])
    @task.update_attributes(task_params)
    @task_list = @task.task_list
    get_tasks
  end

  def delete_task
    @task = Pms::Task.find(params[:task_id])
    @task_list = @task.task_list
    @task.destroy
    get_tasks
  end

  def switch_task_completion
    @task = Pms::Task.find(params[:task_id])
    @task.update_attribute(:completed, !@task.completed)
    @task_list = @task.task_list
    get_tasks
  end

  private

  def get_tasks
    @complete_tasks = @task_list.complete_tasks.order('created_at desc')
    @incomplete_tasks = @task_list.incomplete_tasks.order('created_at desc')
  end

  def set_task_lisk
    @task_list = Pms::TaskList.find(params[:id])
  end

  def task_list_params
    params.require(:pms_task_list)
    .permit(
        :title, :description, :project_id, :taskable_id, :taskable_type
    )
  end

  def task_params
    params.require(:pms_task)
    .permit(
        :due_date, :task_list_id, :description, tasks_users_attributes: [:id, :user_id, :_destroy]
    )
  end
end
