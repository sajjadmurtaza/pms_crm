class CreateCoreSettings < ActiveRecord::Migration
  def change
    create_table :core_settings do |t|
      t.string :name, default: '', null: false
      t.text :value
      t.datetime :updated_on
    end
    add_index :core_settings, :name
  end
end
