class CreateCoreNotes < ActiveRecord::Migration
  def change
    create_table :core_notes do |t|

      t.integer :user_id
      t.references :notable, :polymorphic => true
      t.text :content
      t.text :note_fields
      t.string :note_attachment
      t.integer :note_type_id

      t.timestamps
    end
  end
end
