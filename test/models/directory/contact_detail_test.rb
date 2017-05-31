# == Schema Information
#
# Table name: directory_contact_details
#
#  id            :integer          not null, primary key
#  nick_name     :string(255)
#  company_title :string(255)
#  company_email :string(255)
#  company_phone :string(255)
#  contact_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  skype         :string(255)
#

require 'test_helper'

class Directory::ContactDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
