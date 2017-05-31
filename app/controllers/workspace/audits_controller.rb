class Workspace::AuditsController < ApplicationController
  include Workspace::AuditsHelper
  def index
    @page_title = ''
    @project_audits = separate_notes('Pms::Project' , Workspace::Audit.order("created_at DESC").where(auditable_type: 'Core::Note'))
    @project_audits = @project_audits + Workspace::Audit.order("created_at DESC").where(auditable_type: 'Pms::Task')

    @lead_audits = separate_notes('Crm::Lead' , Workspace::Audit.order("created_at DESC").where(auditable_type: 'Core::Note'))

    @project_logs = Core::Note.order("created_at DESC").where(notable_type: 'Pms::Project')
    @project_logs = @project_logs + Pms::Task.order("created_at DESC").all

    @lead_logs = Core::Note.order("created_at DESC").where(notable_type: 'Crm::Lead')


    # @notes = Core::Note.all
    # @tasks = Pms::Task.all
    #
    # @notes_tasks = @notes + @tasks

    # puts '*****************************************'
    # puts @audits.inspect
    # puts '*****************************************'
  end
end
