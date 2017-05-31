class AddAncestryToCoreOrganizationUnits < ActiveRecord::Migration
  def change
    add_column :core_organization_units, :ancestry, :string
    add_index :core_organization_units, :ancestry
  end
end
