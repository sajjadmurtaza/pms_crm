class CreateSkillsUserDetails < ActiveRecord::Migration
  def up
    create_table :skills_users do |t|
      t.string  :rating
      t.integer :experience
      t.integer :show_on_profile
      t.references :user
      t.references :skill
      t.timestamps
    end
  end
end
