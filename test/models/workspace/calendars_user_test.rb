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

require 'test_helper'

class Workspace::CalendarsUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
