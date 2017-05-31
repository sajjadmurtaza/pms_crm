class CreateCoreSkypes < ActiveRecord::Migration
  def change
    create_table :core_skypes do |t|
      t.string :name
      t.string :skype_type
      t.timestamps
    end
  end
end
