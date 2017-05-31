class CreateDirectoryContactDetails < ActiveRecord::Migration
  def change
    create_table :directory_contact_details do |t|
      t.string :nick_name
      t.string :company_title
      t.string :company_email
      t.string :company_phone
      t.references :contact
      t.timestamps
    end
  end
end
