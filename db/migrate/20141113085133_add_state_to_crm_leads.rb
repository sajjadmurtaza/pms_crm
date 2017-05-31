class AddStateToCrmLeads < ActiveRecord::Migration
  def change
    add_column :crm_leads, :state, :string
    add_index :crm_leads, :state
  end
end
