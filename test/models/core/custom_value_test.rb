# == Schema Information
#
# Table name: core_custom_values
#
#  id              :integer          not null, primary key
#  customized_id   :integer
#  customized_type :string(255)
#  custom_field_id :integer
#  value           :text
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class Core::CustomValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
