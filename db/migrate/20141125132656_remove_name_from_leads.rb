class RemoveNameFromLeads < ActiveRecord::Migration
  def change
    remove_column :crm_leads, :name
  end
end
