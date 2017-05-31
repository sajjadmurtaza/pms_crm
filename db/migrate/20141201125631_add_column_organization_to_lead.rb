class AddColumnOrganizationToLead < ActiveRecord::Migration
  def change
    add_column :crm_leads, :organization_unit_id, :integer
  end
end
