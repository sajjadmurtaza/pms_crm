class CreateCoreCustomValues < ActiveRecord::Migration
  def change
    create_table :core_custom_values do |t|
      t.references :customized, polymorphic: true
      t.references :custom_field
      t.text :value
      t.timestamps
    end
  end
end
