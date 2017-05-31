# == Schema Information
#
# Table name: crm_leads_contacts
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  lead_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Crm::LeadsContact < ActiveRecord::Base
  belongs_to :contact, class_name: 'Directory::Contact'
  belongs_to :lead, class_name: 'Crm::Lead'

  validates_uniqueness_of :contact_id, scope: [:lead_id]
end
