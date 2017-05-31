class CreateDirectoryRoles < ActiveRecord::Migration
  def change
    create_table :directory_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
