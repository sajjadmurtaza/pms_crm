# == Schema Information
#
# Table name: attachments
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  fileable_id   :integer
#  fileable_type :string(255)
#

require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
