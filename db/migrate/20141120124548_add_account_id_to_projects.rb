class AddAccountIdToProjects < ActiveRecord::Migration
  def change
    add_column :pms_projects, :account_id, :integer
  end
end
