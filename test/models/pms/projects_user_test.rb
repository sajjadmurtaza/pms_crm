# == Schema Information
#
# Table name: pms_projects_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class Pms::ProjectsUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
