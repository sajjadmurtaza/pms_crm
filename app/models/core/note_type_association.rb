# == Schema Information
#
# Table name: core_enumerations
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  value      :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class Core::NoteTypeAssociation <  Core::Enumeration

  audited
  has_many :note_types_associations, class_name: 'Core::NoteTypesAssociations', dependent: :destroy, foreign_key:  :association_id
  has_many :assigned_note_types, through: :note_types_associations, source: :note_type
end
