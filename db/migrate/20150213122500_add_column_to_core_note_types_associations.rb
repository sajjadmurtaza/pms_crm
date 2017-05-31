class AddColumnToCoreNoteTypesAssociations < ActiveRecord::Migration
  def change
    add_column :core_note_types_associations, :commentable, :boolean, default: false
  end
end
