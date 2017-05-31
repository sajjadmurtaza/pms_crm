class CreatePmsProjectsContacts < ActiveRecord::Migration
  def change
    create_table :pms_projects_contacts do |t|

      t.integer :contact_id
      t.integer :project_id
      t.timestamps
    end
  end
end
