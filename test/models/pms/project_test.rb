# == Schema Information
#
# Table name: pms_projects
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :text
#  start_date       :date
#  end_date         :date
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  account_id       :integer
#  manager_id       :integer
#  planned_end_date :date
#  cost             :float
#  status_id        :integer
#  percentage_done  :integer
#  lead_id          :integer
#

require 'test_helper'

class Pms::ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
