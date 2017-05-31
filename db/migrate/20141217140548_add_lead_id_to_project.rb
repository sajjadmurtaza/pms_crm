class AddLeadIdToProject < ActiveRecord::Migration
  def change
    add_column :pms_projects, :lead_id, :integer
  end
end
