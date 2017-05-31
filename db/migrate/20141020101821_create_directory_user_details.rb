class CreateDirectoryUserDetails < ActiveRecord::Migration
  def change
    create_table :directory_user_details do |t|
      t.string :emp_id
      t.string :education
      t.string :experience

      t.string :summery
      t.string :the_most_amazing
      t.string :perfered_development_environment
      t.string :organization_unit_id

      t.string :calling_name
      t.date :appointment_date
      t.integer :job_title_id
      t.integer :location_id

      t.integer :primary_role_id
      t.string :secondary_roles

      t.references :user
      t.timestamps
    end
  end
end
