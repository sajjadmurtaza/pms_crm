class CreateCoreRoles < ActiveRecord::Migration
  def change
    create_table :core_roles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
