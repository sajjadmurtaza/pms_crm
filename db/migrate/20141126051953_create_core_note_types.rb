class CreateCoreNoteTypes < ActiveRecord::Migration
  def change
    create_table :core_note_types do |t|
      t.string :name
      t.boolean :default, default: false
      t.timestamps
    end
  end
end
