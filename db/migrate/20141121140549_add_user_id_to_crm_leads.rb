class AddUserIdToCrmLeads < ActiveRecord::Migration
  def change
    add_reference :crm_leads, :user, index: true
  end
end
