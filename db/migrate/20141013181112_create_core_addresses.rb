class CreateCoreAddresses < ActiveRecord::Migration
  def change
    create_table :core_addresses do |t|
      t.string    :address1
      t.string    :address2
      t.string    :address_type
      t.string    :city
      t.string    :zip
      t.string    :state
      t.string    :country

      t.references :addressable, :polymorphic => true
      t.timestamps
    end
  end
end
