class CreatePmsProjectsUsers < ActiveRecord::Migration
  def change
    create_table :pms_projects_users do |t|

      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
  end
end
