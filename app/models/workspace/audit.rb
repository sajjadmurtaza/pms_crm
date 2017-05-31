# == Schema Information
#
# Table name: audits
#
#  id              :integer          not null, primary key
#  auditable_id    :integer
#  auditable_type  :string(255)
#  associated_id   :integer
#  associated_type :string(255)
#  user_id         :integer
#  user_type       :string(255)
#  username        :string(255)
#  action          :string(255)
#  audited_changes :text
#  version         :integer          default(0)
#  comment         :string(255)
#  remote_address  :string(255)
#  request_uuid    :string(255)
#  created_at      :datetime
#
# Indexes
#
#  associated_index              (associated_id,associated_type)
#  auditable_index               (auditable_id,auditable_type)
#  index_audits_on_created_at    (created_at)
#  index_audits_on_request_uuid  (request_uuid)
#  user_index                    (user_id,user_type)
#

class Workspace::Audit < ActiveRecord::Base
  serialize :audited_changes, Hash
  self.table_name = 'audits'
  belongs_to :auditable, :polymorphic => true
  belongs_to :user, :class_name => "Directory::User"

  def project_or_lead_name
  	return auditable.project.title if (auditable_type == "Core::Invoice" and auditable and auditable.project)
  	return auditable.lead.name if (auditable_type == "Core::Invoice" and auditable and auditable.lead)
  	return nil
  end
  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
    	id: id,
    	action: action,
        auditable_type: auditable_type,
        user: (user ? [user.first_name, user.last_name, user.username] : []),
        auditable_invoice_on_name: project_or_lead_name,
        created_date: created_at.strftime("%Y-%m-%d")
    }
  end

  def self.filter_options
    {
        filter_box: [
            {key: :user, label: 'Created By'},   
        ],
        filter_aggregates: [
        	{key: :action, label: 'Action', collection: self.all.inject({}) { |h, t| h[t.action] = (t.action=="create" ? "new" : t.action); h }}
        ]
    }
  end
  #-----------------------------------------------------
end
