class CreatePmsTasksUsers < ActiveRecord::Migration
  def change
    create_table :pms_tasks_users do |t|

      t.integer :user_id
      t.integer :task_id
      t.timestamps
    end
  end
end
