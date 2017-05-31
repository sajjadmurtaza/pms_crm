class Core::ActivityLogsController < ApplicationController
  before_action :set_filter_params
  before_action :set_sort_params, :only => [:invoice_log, :lead_log]

  def project_log
    @page_title = 'Projects'
    # @project_logs = Core::Note.order("created_at DESC").where(notable_type: 'Pms::Project').where(filters_query(params[:filters]))
    params["q"]["search_params"] ||= {}
    params["q"]["aggregate_params"] ||= {}
    show_notes = true
    if !params["q"]["aggregate_params"].empty?
      @show_tasks = @tasks_aggregate = params["q"]["aggregate_params"].delete("special_task")
      @show_comments = @comments_aggregate = params["q"]["aggregate_params"].delete("special_comment")
      show_notes = !params["q"]["aggregate_params"].empty?
    else
      @show_tasks = @show_comments = true
    end
    # TODO use Pms::Project instead of Project
    @project_logs = []    
    params["q"]["search_params"][:notable_type] = "Project"
    @search = ESSearch.new
    @search.klass = Core::Note
    @search.init_params params, false
    @search.load_records = false
    if show_notes
      @project_logs = @search.search.records#.where(filters_query(params[:filters]))
    else
      @search.search.records
    end
    
    # find task logs
    task_search = ESSearch.new
    task_search.klass = Pms::Task
    task_search.init_params get_task_search_params, false
    task_search.load_records = false
    task_logs = task_search.search.records#.where(filters_query(params[:filters]))
    @tasks_count = task_logs.length
    @project_logs += task_logs if @show_tasks
    # @project_logs = @project_logs + Pms::Task.order("created_at DESC").all.where(filters_query(params[:filters]))

    # find comment logs
    comment_search = ESSearch.new
    comment_search.klass = Core::Comment
    comment_search.init_params get_comment_search_params, false
    comment_search.load_records = false
    comment_logs = comment_search.search.records#.where(filters_query(params[:filters]))
    @comments_count = comment_logs.length
    @project_logs += comment_logs if @show_comments
      # @project_logs = @project_logs + Core::Comment.order("created_at DESC").where(commentable_type: 'Pms::Task').where(filters_query(params[:filters]))

    @project_logs = @project_logs.sort_by(&:created_at).reverse
    # @project_logs = @project_logs.group_by(&:class).collect { |key,val| val.sort_by(&:created_at).reverse }.flatten
    # @project_logs = @project_logs
    @project_logs = Kaminari.paginate_array(@project_logs).page(params[:page]).per(params[:per_page])
  end

  def lead_log
    @page_title = 'Leads'
    params["q"]["search_params"] ||= {}
    # TODO use Crm::Lead instead of Lead
    params["q"]["search_params"][:notable_type] = "Lead"
    @search = ESSearch.new
    @search.klass = Core::Note
    @search.init_params params, false
    @search.load_records = false
    @lead_logs = @search.search.records#.order("created_at DESC")#.where(filters_query(params[:filters]))

    # @lead_logs = Core::Note.order("created_at DESC").where(notable_type: 'Crm::Lead').where(filters_query(params[:filters]))
    # @lead_logs = Kaminari.paginate_array(@lead_logs).page(params[:page]).per(params[:per_page])
  end

  def invoice_log
    @page_title = 'Invoices'
    params["q"]["search_params"] ||= {}
    # TODO use Crm::Lead instead of Lead
    params["q"]["search_params"][:auditable_type] = "Invoice"
    @search = ESSearch.new
    @search.klass = Workspace::Audit
    @search.init_params params#, false
    @search.load_records = false
    @invoice_logs = @search.search.records#.order("created_at DESC")#.where(filters_query(params[:filters]))
    # @invoice_logs = Workspace::Audit.order("created_at DESC").where(auditable_type: 'Core::Invoice').where(filters_query(params[:filters]))
    # @invoice_logs = Kaminari.paginate_array(@invoice_logs).page(params[:page]).per(params[:per_page])
  end

private

  # def filters_query(filters)
  #   start_date = filters[:start_date]
  #   end_date = filters[:end_date]
  #   "#{((start_date and start_date != '') ? 'created_at >= \'' + start_date + '\'' : '') + (((start_date and start_date != '') and (end_date and end_date != '')) ? ' AND ' : '') + ((end_date and end_date != '') ? 'created_at <= \'' + end_date + '\'' : '')}"
  # end

  def set_filter_params
    params[:filters] ||= {}
    params["q"] ||= {}
    params["q"]["filter_params"] ||= {}
    start_date = params[:filters][:start_date]
    end_date = params[:filters][:end_date]
    if start_date and start_date != ''
      params["q"]["filter_params"]['created_date'] = {'gte' => start_date}
    end
    if end_date and end_date != ''
      params["q"]["filter_params"]['created_date'] ||= {}
      params["q"]["filter_params"]['created_date']['lte'] = end_date
    end
  end

  def set_sort_params
    params["q"] ||= {}
    params["q"]["sort_params"] ||= {}
    params["q"]["sort_params"]['id'] = 'desc'
  end

  def get_task_search_params
    task_search_params = params.deep_dup
    task_search_params["q"]["aggregate_params"] = {}
    task_search_params["q"]["search_params"] = {}#{user: params["q"]["search_params"][:user], project: params["q"]["search_params"][:user], description: params["q"]["search_params"][:content]}
    search_params = params["q"]["search_params"]
    task_search_params["q"]["search_params"] = task_search_params["q"]["search_params"].merge({ "user" => search_params["user"] }) if search_params["user"]
    task_search_params["q"]["search_params"] = task_search_params["q"]["search_params"].merge({ "project" => search_params["notable_name"] }) if search_params["notable_name"]
    task_search_params["q"]["search_params"] = task_search_params["q"]["search_params"].merge({ "description" => search_params["content"] }) if search_params["content"]
    task_search_params
  end
  
  def get_comment_search_params
    comment_search_params = params.deep_dup
    # TODO use Pms::Task instead of Task
    comment_search_params["q"]["aggregate_params"] = {}
    comment_search_params["q"]["search_params"] = {"commentable_type" => "Task"}#{user: params["q"]["search_params"][:user], project: params["q"]["search_params"][:user], description: params["q"]["search_params"][:content]}
    search_params = params["q"]["search_params"]
    comment_search_params["q"]["search_params"] = comment_search_params["q"]["search_params"].merge({ "user" => search_params["user"] }) if search_params["user"]
    comment_search_params["q"]["search_params"] = comment_search_params["q"]["search_params"].merge({ "notable_name" => search_params["notable_name"] }) if search_params["notable_name"]
    comment_search_params["q"]["search_params"] = comment_search_params["q"]["search_params"].merge({ "comment" => search_params["content"] }) if search_params["content"]
    comment_search_params
  end
end
