# == Schema Information
#
# Table name: core_notes
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notable_id      :integer
#  notable_type    :string(255)
#  content         :text
#  note_fields     :text
#  note_attachment :string(255)
#  note_type_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  note_id         :integer
#

require 'test_helper'

class Core::NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
