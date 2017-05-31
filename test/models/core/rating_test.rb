# == Schema Information
#
# Table name: core_ratings
#
#  id            :integer          not null, primary key
#  value         :float
#  rateable_id   :integer
#  rateable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class Core::RatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
