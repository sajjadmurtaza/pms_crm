class CreatePmsTaskLists < ActiveRecord::Migration
  def change
    create_table :pms_task_lists do |t|
      t.string :title
      t.references :taskable, polymorphic: true
      t.timestamps
    end
  end
end
