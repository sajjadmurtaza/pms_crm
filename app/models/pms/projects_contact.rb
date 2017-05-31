# == Schema Information
#
# Table name: pms_projects_contacts
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Pms::ProjectsContact < ActiveRecord::Base
  audited

  belongs_to :contact, class_name: 'Directory::Contact'
  belongs_to :project, class_name: 'Pms::Project'

  validates_uniqueness_of :contact_id, scope: [:project_id]

end
