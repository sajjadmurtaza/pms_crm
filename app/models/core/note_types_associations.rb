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

class Core::NoteTypesAssociations < ActiveRecord::Base
  belongs_to :note_type, class_name: 'Core::NoteType'
  belongs_to :note_type_association, class_name: 'Core::NoteTypeAssociation', foreign_key: :association_id
end
