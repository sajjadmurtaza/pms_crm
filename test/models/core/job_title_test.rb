# == Schema Information
#
# Table name: core_enumerations
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  value      :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

require 'test_helper'

class Core::JobTitleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
