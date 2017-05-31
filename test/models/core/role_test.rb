# == Schema Information
#
# Table name: core_roles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class Core::RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
