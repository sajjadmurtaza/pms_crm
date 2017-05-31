# == Schema Information
#
# Table name: crm_leads
#
#  id                   :integer          not null, primary key
#  email                :string(255)
#  skype                :string(255)
#  technology           :string(255)
#  source_id            :integer
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  state                :string(255)
#  user_id              :integer
#  phone                :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  organization_unit_id :integer
#
# Indexes
#
#  index_crm_leads_on_state    (state)
#  index_crm_leads_on_user_id  (user_id)
#

require 'test_helper'

class Crm::LeadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
