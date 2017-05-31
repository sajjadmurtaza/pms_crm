class CreateCoreQuotes < ActiveRecord::Migration
  def change
    create_table :core_quotes do |t|
      t.float :amount
      t.text :description
      t.integer :invoice_split_id
      t.date :quote_date
      t.integer :project_id
      t.integer :lead_id
      t.references :reference, polymorphic: true, index: true

      t.timestamps
    end
  end
end
