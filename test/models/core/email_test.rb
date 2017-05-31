# == Schema Information
#
# Table name: core_emails
#
#  id             :integer          not null, primary key
#  email          :string(255)
#  email_type     :string(255)
#  emailable_id   :integer
#  emailable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class Core::EmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
