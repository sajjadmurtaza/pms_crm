# == Schema Information
#
# Table name: workspace_calendar_entries
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  description    :text
#  start_date     :date
#  end_date       :date
#  calendar_id    :integer
#  reference_id   :integer
#  reference_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_workspace_calendar_entries_on_reference_id    (reference_id)
#  index_workspace_calendar_entries_on_reference_type  (reference_type)
#

class Workspace::CalendarEntry < ActiveRecord::Base
  belongs_to :reference,class_name: 'Workspace::CalendarEntry', polymorphic: true
  belongs_to :calendar, class_name: 'Workspace::Calendar', foreign_key: :calendar_id

  validates :title, :start_date, :end_date, presence: true

  audited only: [:title, :description, :start_date, :end_date], on: [:create, :update, :destroy], associated_with: :reference

  after_update :update_entity

  def update_entity
    unless self.reference.nil?
      reference.due_date = self.end_date if (reference.has_attribute?(:due_date))
      reference.save
    end
  end

end
