class AddColumnStatusIdInQuotes < ActiveRecord::Migration
  def change
    add_column :core_quotes, :status_id, :integer
  end
end
