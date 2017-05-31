# == Schema Information
#
# Table name: directory_accounts
#
#  id             :integer          not null, primary key
#  account_number :string(255)
#  title          :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class Directory::AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
