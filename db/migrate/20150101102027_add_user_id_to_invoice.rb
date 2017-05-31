class AddUserIdToInvoice < ActiveRecord::Migration
  def change
    add_column :core_invoices, :user_id, :integer
  end
end
