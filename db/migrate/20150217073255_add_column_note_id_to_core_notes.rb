class AddColumnNoteIdToCoreNotes < ActiveRecord::Migration
  def change
  	add_column :core_notes, :note_id, :integer
  end
end
