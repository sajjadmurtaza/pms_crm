class CreateCoreEmails < ActiveRecord::Migration
  def change
    create_table :core_emails do |t|
      t.string :email
      t.string :email_type

      t.references :emailable, :polymorphic => true
      t.timestamps
    end
  end
end
