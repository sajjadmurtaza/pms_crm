class CreateCrmLeadsContacts < ActiveRecord::Migration
  def change
    create_table :crm_leads_contacts do |t|
      t.integer :contact_id
      t.integer :lead_id

      t.timestamps
    end
  end
end
