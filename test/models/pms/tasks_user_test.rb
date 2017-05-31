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

require 'test_helper'

class Pms::TasksUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
