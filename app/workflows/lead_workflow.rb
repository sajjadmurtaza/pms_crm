class LeadWorkflow < Heyday::Workflow::Base
  def initialize(lead=nil)
    super Rails.root.join('config', 'lead_workflow.yml'), lead
  end
end