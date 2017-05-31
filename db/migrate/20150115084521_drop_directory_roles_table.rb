class DropDirectoryRolesTable < ActiveRecord::Migration
  def change
    drop_table :directory_roles
  end
end
