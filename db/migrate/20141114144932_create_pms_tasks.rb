class CreatePmsTasks < ActiveRecord::Migration
  def change
    create_table :pms_tasks do |t|
      t.text :description
      t.references :task_list
      t.integer :user_id
      t.date :due_date
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
