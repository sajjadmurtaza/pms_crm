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

require 'test_helper'

class Workspace::CalendarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
