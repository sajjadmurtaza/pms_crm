class Pms::TasksController < ApplicationController
  def show
    @task = Pms::Task.find(params[:id])
    @page_title = @task.task_list.taskable.title
  end
end
