class CreateCorePortfolioItems < ActiveRecord::Migration
  def change
    create_table :core_portfolio_items do |t|
      t.string :title
      t.string :description
      t.string :responsibilities
      t.string :url
      t.string :tools_and_tech

      t.references :portfolioable, polymorphic:true
      t.timestamps
    end
  end
end
