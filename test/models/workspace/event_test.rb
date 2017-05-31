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

require 'test_helper'

class Workspace::EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
