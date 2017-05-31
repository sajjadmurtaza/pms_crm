# == Schema Information
#
# Table name: crm_leads_contacts
#
#  id         :integer          not null, primary key
#  contact_id :integer
#  lead_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class Crm::LeadsContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
