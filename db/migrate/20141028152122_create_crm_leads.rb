class CreateCrmLeads < ActiveRecord::Migration
  def change
    create_table :crm_leads do |t|
      t.string :name
      t.string :email
      t.string :skype
      t.string :technology
      t.integer :source_id
      t.string :description

      t.timestamps
    end
  end
end
