class CreateWorkspaceCalendarEntries < ActiveRecord::Migration
  def change
    create_table :workspace_calendar_entries do |t|
      t.string :title
      t.string :description
      t.date :start_date
      t.date :end_date
      t.references :calendar
      t.references :reference, polymorphic: true
      t.timestamps
    end
    add_index :workspace_calendar_entries, :reference_id
    add_index :workspace_calendar_entries, :reference_type
  end
end
