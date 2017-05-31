class AddManagerIdToProjects < ActiveRecord::Migration
  def change
    add_column :pms_projects, :manager_id, :integer
  end
end
