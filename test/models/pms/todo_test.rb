# == Schema Information
#
# Table name: pms_todos
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  project_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class Pms::TodoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
