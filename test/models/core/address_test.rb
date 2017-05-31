# == Schema Information
#
# Table name: core_addresses
#
#  id               :integer          not null, primary key
#  address1         :string(255)
#  address2         :string(255)
#  address_type     :string(255)
#  city             :string(255)
#  zip              :string(255)
#  state            :string(255)
#  country          :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class Core::AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
