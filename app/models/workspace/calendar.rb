# == Schema Information
#
# Table name: workspace_calendars
#
#  id             :integer          not null, primary key
#  system_user_id :integer
#  name           :string(255)
#  color          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  reference_id   :integer
#  reference_type :string(255)
#
# Indexes
#
#  index_workspace_calendars_on_reference_id_and_reference_type  (reference_id,reference_type)
#

class Workspace::Calendar < ActiveRecord::Base
  audited only: [:name, :color], on: [:create, :update, :destroy]
  belongs_to :user, foreign_key: :system_user_id, class_name: 'Core::SystemUser'
  has_many :calendar_entries, class_name: 'Workspace::CalendarEntry', dependent: :destroy
  belongs_to :reference, polymorphic: true

  has_many :calendars_users, class_name: 'Workspace::CalendarsUser', dependent: :destroy
  has_many :shared_users, through: :calendars_users, class_name: 'Core::SystemUser', source: :system_user

  accepts_nested_attributes_for :calendars_users, :reject_if => :all_blank, :allow_destroy => true

  validates :name,:color, presence: true
end
