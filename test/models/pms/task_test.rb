# == Schema Information
#
# Table name: pms_tasks
#
#  id           :integer          not null, primary key
#  description  :text
#  task_list_id :integer
#  user_id      :integer
#  due_date     :date
#  completed    :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class Pms::TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
