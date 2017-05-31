class CreateCoreRatings < ActiveRecord::Migration
  def change
    create_table :core_ratings do |t|
      t.float :value

      t.references :rateable, :polymorphic => true
      t.timestamps
    end
  end
end
