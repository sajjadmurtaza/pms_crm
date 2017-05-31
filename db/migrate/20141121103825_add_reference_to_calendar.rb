class AddReferenceToCalendar < ActiveRecord::Migration
  def change
    add_reference :workspace_calendars, :reference, index: true, polymorphic: true
  end
end
