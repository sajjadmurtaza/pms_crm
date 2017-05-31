class CreateCorePhones < ActiveRecord::Migration
  def change
    create_table :core_phones do |t|
      t.string      :phone
      t.string      :phone_type

      t.references  :phoneable, :polymorphic => true
      t.timestamps
    end
  end
end
