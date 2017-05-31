class Workspace::UserAssignmentsController < ApplicationController
  def index
    @page_title = 'My Tasks'
    @assignments = current_user.assigned_tasks.where(completed: false).order('created_at DESC')
    @assignments = Kaminari.paginate_array(@assignments).page(params[:page]).per(params[:per_page])
  end

  def switch_task_completed
    @task = Pms::Task.find(params[:task_id])
    @task.update_attribute(:completed, !@task.completed)
    # render js: "window.location= '#{task_assignments_url}'"
    # end
    p '*********************************************************************************************'
    
    p '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
  end

  def completed_tasks
    @page_title = 'My Completed Tasks'
    @completed_assignments = current_user.assigned_tasks.where(completed: true).order('updated_at DESC')
    @completed_assignments = Kaminari.paginate_array(@completed_assignments).page(params[:page]).per(params[:per_page])
  end
end
