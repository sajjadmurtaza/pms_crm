class CreateCoreEnumerations < ActiveRecord::Migration
  def change
    create_table :core_enumerations do |t|
      t.string :name, null: false
      t.string :value
      t.string :type
      t.integer :position

      t.timestamps
    end
  end
end
