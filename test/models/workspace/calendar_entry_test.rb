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

require 'test_helper'

class Workspace::CalendarEntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
