class AddColumnsToPmsProjects < ActiveRecord::Migration
  def change
    add_column :pms_projects, :planned_end_date, :date
    add_column :pms_projects, :cost, :integer
    add_column :pms_projects, :status_id, :integer
    add_column :pms_projects, :percentage_done, :integer
  end
end
