class AddBillableToPmsTaskList < ActiveRecord::Migration
  def change
    add_column :pms_task_lists, :billable, :boolean
  end
end
