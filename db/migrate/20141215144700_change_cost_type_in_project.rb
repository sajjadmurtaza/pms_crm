class ChangeCostTypeInProject < ActiveRecord::Migration
  def change
    change_column :pms_projects, :cost, :float
  end
end
