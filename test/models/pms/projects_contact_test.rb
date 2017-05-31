# == Schema Information
#
# Table name: pms_projects_contacts
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class Pms::ProjectsContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
