class Core::WorkflowController < ApplicationController
  before_action :load_source_object

  def validate_transition
    @current_state = @workflow.current_state
    if transition = @workflow.can_transit_to?(@target_state)
      if  @workflow.transitions[transition.to_sym].last == @current_state # check If transition is being reverted
        make_transition
        response = { before: [],
                     after: []
        }
        render json: response
      else
        response = {before: @workflow.send(:fetch_actions, :before, transition),
                  after: @workflow.send(:fetch_actions, :after, transition), }
        render json: response
      end
    else
      response = {
          msg: "Can't tranist from <strong>#{@current_state.capitalize}</strong> to <strong>#{@target_state.capitalize}</strong>."
      }
      render json: response, status: 400
    end
  end

  def perform_action
    @action_name = params[:action_name]
    @action_result = @workflow.send(:perform_action, @action_name.to_sym, target_state: @target_state)
    @title = @workflow.actions[@action_name.to_sym][:title]
    if @workflow.actions[@action_name.to_sym][:type] == 'frontend'
      render partial: 'action'
    else
      render partial: 'action_completed'
    end
  end

  def perform_action_frontend
    @action_name = params[:action_name]
    params[:user] = current_user
    params[:source] = @source
    params[:target_state] = @target_state
    @workflow.actions[@action_name.to_sym][:action_class].constantize.new.after_frontend(params)

  end

  def make_transition
     @workflow.source.update_attribute @workflow.source.class.state_column, @target_state
  end

  private

  def load_source_object
    @source_type = params[:source_type]
    @source_id = params[:source_id]
    @source = @source_type.constantize.find(@source_id)
    @workflow = @source.workflow
    @target_state = params[:target_state]
    @initial_state = params[:initial_state]
  end
end
