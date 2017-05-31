# == Schema Information
#
# Table name: directory_user_details
#
#  id                               :integer          not null, primary key
#  emp_id                           :string(255)
#  education                        :string(255)
#  experience                       :string(255)
#  summery                          :string(255)
#  the_most_amazing                 :string(255)
#  perfered_development_environment :string(255)
#  organization_unit_id             :string(255)
#  calling_name                     :string(255)
#  appointment_date                 :date
#  job_title_id                     :integer
#  location_id                      :integer
#  primary_role_id                  :integer
#  secondary_roles                  :string(255)
#  user_id                          :integer
#  created_at                       :datetime
#  updated_at                       :datetime
#

class Directory::UserDetail < ActiveRecord::Base
  audited
  belongs_to :directory_user, :class_name => 'Directory::User'
  belongs_to :primary_role, class_name: 'Core::Role', autosave: true
  belongs_to :job_title, class_name: 'Core::JobTitle', autosave: true
  belongs_to :location, class_name: 'Core::Location', autosave: true
  belongs_to :organization_unit, :class_name => 'Core::OrganizationUnit', autosave: true

  validates :emp_id, presence: true, uniqueness: true
end
