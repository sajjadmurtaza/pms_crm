class CreateWorkspaceCalendars < ActiveRecord::Migration
  def change
    create_table :workspace_calendars do |t|
      t.integer :system_user_id
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
