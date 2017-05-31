class CreateCoreOrganizationUnits < ActiveRecord::Migration
  def change
    create_table :core_organization_units do |t|
      t.string :title
      t.string :role

      t.timestamps
    end
  end
end
