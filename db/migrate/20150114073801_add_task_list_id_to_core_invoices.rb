class AddTaskListIdToCoreInvoices < ActiveRecord::Migration
  def change
    add_column :core_invoices, :task_list_id, :integer
  end
end
