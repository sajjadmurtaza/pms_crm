class CreateWorkspaceEvents < ActiveRecord::Migration
  def change
    create_table :workspace_events do |t|
      t.string :title
      t.integer :calendar_id
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
