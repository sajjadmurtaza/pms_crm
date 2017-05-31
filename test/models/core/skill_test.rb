# == Schema Information
#
# Table name: core_skills
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  skill_type_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class Core::SkillTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
