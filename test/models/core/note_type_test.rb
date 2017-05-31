# == Schema Information
#
# Table name: core_note_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  default    :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class Core::NoteTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
