# == Schema Information
#
# Table name: core_phones
#
#  id             :integer          not null, primary key
#  phone          :string(255)
#  phone_type     :string(255)
#  phoneable_id   :integer
#  phoneable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class Core::PhoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
