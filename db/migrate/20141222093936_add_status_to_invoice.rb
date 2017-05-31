class AddStatusToInvoice < ActiveRecord::Migration
  def change
    add_column :core_invoices, :status_id, :integer
  end
end
