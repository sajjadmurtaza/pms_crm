class CreateCoreSkills < ActiveRecord::Migration
  def change
    create_table :core_skills do |t|
      t.string :name
      t.references :skill_type

      t.timestamps
    end
  end
end
