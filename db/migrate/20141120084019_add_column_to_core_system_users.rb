class AddColumnToCoreSystemUsers < ActiveRecord::Migration
  def change
    add_column :core_system_users, :last_login_at, :string
  end
end
