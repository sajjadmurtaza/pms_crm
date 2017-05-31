class AddPhoneToCoreSystemUsers < ActiveRecord::Migration
  def change
    add_column :core_system_users, :phone, :string
  end
end
