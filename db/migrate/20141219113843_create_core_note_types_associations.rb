class CreateCoreNoteTypesAssociations < ActiveRecord::Migration
  def change
    create_table :core_note_types_associations do |t|
      t.integer :note_type_id
      t.integer :association_id
      t.boolean :default

      t.timestamps
    end
  end
end
