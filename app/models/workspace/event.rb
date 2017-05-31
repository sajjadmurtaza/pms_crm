# == Schema Information
#
# Table name: workspace_events
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  calendar_id :integer
#  start       :date
#  end         :date
#  created_at  :datetime
#  updated_at  :datetime
#

class Workspace::Event < ActiveRecord::Base
  audited only: [:title, :start, :end], on: [:create, :update, :destroy]
  belongs_to :workspace_calendar, :class_name => 'Workspace::Calendar'

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
  {
        title: title,
        start: start,
        end: self.end,
        calendar_id: calendar_id
  }
  end
end
