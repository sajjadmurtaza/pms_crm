class CreateDirectoryAccounts < ActiveRecord::Migration
  def change
    create_table :directory_accounts do |t|
      t.string :account_number
      t.string :title
      t.string :email

      t.timestamps
    end
  end
end
