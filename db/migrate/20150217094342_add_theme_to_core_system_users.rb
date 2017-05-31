class AddThemeToCoreSystemUsers < ActiveRecord::Migration
  def change
    add_column :core_system_users, :theme, :string
  end
end
