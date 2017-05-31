# == Schema Information
#
# Table name: pms_projects_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Pms::ProjectsUser < ActiveRecord::Base
  audited

  belongs_to :user, class_name: 'Directory::User'
  belongs_to :project, class_name: 'Pms::Project'

  validates_uniqueness_of :user_id, scope: [:project_id]

end
