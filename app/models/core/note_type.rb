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

class Core::NoteType < ActiveRecord::Base
  has_many :note_types_associations, class_name: 'Core::NoteTypesAssociations', dependent: :destroy
  has_many :assigned_associations, through: :note_types_associations, foreign_key: 'association_id', source: :note_type_association

  has_many :notes, :class_name => 'Core::Note'
  scope :application_default, -> { where(default: true).first }

  accepts_nested_attributes_for :note_types_associations, :reject_if => :all_blank, :allow_destroy => true

  def custom_fields
    Core::NoteCustomField.where( "meta LIKE '%[note_type:#{self.id}]%'")
  end

  def self.default(associated_entity)
    note_type = Core::NoteTypeAssociation.find_by_name(associated_entity).try(:note_types_associations).where(default: true).try(:first).try(:note_type)
  end

  def self.find id
    (id == 0 || id == "0") ? (new id: 0, name: "Comment") : super
  end

end
