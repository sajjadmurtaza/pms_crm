# == Schema Information
#
# Table name: core_note_types_associations
#
#  id             :integer          not null, primary key
#  note_type_id   :integer
#  association_id :integer
#  default        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  commentable    :boolean          default(FALSE)
#

require 'test_helper'

class Core::NoteTypesAssociationsTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
