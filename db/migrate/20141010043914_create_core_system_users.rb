class CreateCoreSystemUsers < ActiveRecord::Migration
  def change
    create_table :core_system_users do |t|
      t.string :first_name,         :null => false
      t.string :last_name,          :null => false
      t.string :username,           :null => true
      t.string :email,              :null => true
      t.string :crypted_password,   :null => true
      t.string :salt,               :null => true
      t.string :remember_me_token, :default => nil
      t.datetime  :remember_me_token_expires_at, :default => nil
      t.string :auth_mode
      t.string :time_zone
      t.string :type
      t.timestamps
    end

    add_index :core_system_users, :email
    add_index :core_system_users, :remember_me_token
    add_index :core_system_users, :type
  end
end
