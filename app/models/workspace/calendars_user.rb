# == Schema Information
#
# Table name: workspace_calendars_users
#
#  id             :integer          not null, primary key
#  system_user_id :integer
#  calendar_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Workspace::CalendarsUser < ActiveRecord::Base
  belongs_to :calendar, class_name: 'Workspace::Calendar'
  belongs_to :system_user, class_name: 'Core::SystemUser'
end
