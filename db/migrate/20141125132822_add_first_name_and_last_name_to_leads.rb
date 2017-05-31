class AddFirstNameAndLastNameToLeads < ActiveRecord::Migration
  def change
    add_column :crm_leads, :first_name, :string
    add_column :crm_leads, :last_name, :string
  end
end
