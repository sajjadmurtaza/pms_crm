class AddColumnToDirectoryContactDetails < ActiveRecord::Migration
  def change
    add_column :directory_contact_details, :skype, :string
  end
end
