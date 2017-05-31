class CreatePmsProjects < ActiveRecord::Migration
  def change
    create_table :pms_projects do |t|

      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.integer :user_id
      t.timestamps
    end
  end
end
