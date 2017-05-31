class CreateCoreInvoices < ActiveRecord::Migration
  def change
    create_table :core_invoices do |t|
      t.date :due_date
      t.integer :organization_unit_id
      t.text :invoice_project
      t.text :invoice_task
      t.float :cost
      t.integer :split_type_id
      t.references :reference, :polymorphic => true
      t.integer :project_id, index: true
      t.integer :lead_id, index: true

      t.timestamps
    end
  end
end
