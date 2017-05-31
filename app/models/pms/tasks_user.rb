# == Schema Information
#
# Table name: pms_tasks_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Pms::TasksUser < ActiveRecord::Base
  audited

  belongs_to :user, class_name: 'Directory::User'
  belongs_to :task, class_name: 'Pms::Task'

  validates_uniqueness_of :user_id, scope: [:task_id]
end
