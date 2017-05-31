class CreateWorkspaceCalendarsUsers < ActiveRecord::Migration
  def change
    create_table :workspace_calendars_users do |t|
      t.integer :system_user_id
      t.integer :calendar_id

      t.timestamps
    end
  end
end
