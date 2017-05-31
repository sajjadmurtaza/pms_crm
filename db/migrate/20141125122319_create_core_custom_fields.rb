class CreateCoreCustomFields < ActiveRecord::Migration
  def change
    create_table :core_custom_fields do |t|
      t.string :type, limit: 30, default: '', null: false
      t.string :field_format, limit: 30, default: '', null: false
      t.string :regexp, default: ''
      t.integer :min_length, default: 0, null: false
      t.integer :max_length, default: 0, null: false
      t.boolean :required, default: false
      t.boolean :editable, default: true
      t.boolean :searchable, default: false
      t.boolean :scheduleable, default: false

      t.string :name, null: false
      t.text :default_value
      t.text :possible_values

      t.integer :position, default: 0
      t.text  :meta

      t.timestamps
    end
    add_index :core_custom_fields, :type
  end
end
