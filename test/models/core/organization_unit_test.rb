# == Schema Information
#
# Table name: core_organization_units
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#
# Indexes
#
#  index_core_organization_units_on_ancestry  (ancestry)
#

require 'test_helper'

class Core::OrganizationUnitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
