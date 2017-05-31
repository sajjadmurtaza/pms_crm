class AddPhoneToCrmLeads < ActiveRecord::Migration
  def change
    add_column :crm_leads, :phone, :string
  end
end
