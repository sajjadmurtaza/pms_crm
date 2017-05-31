class ChangeDescriptionToText < ActiveRecord::Migration
  def change
    change_column :core_portfolio_items ,:description, :text
    change_column :crm_leads ,:description, :text
    change_column :workspace_calendar_entries,:description, :text
  end
end
