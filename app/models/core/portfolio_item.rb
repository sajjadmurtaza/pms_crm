# == Schema Information
#
# Table name: core_portfolio_items
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  description        :text
#  responsibilities   :string(255)
#  url                :string(255)
#  tools_and_tech     :string(255)
#  portfolioable_id   :integer
#  portfolioable_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Core::PortfolioItem < ActiveRecord::Base
  belongs_to :portfolioable, polymorphic: true
  audited only: [:description, :responsibilities, :url, :tools_and_tech], on: [:create, :update, :destroy], associated_with: :portfolioable

  validates :description, presence:true
  validates :url, presence:true, uniqueness: true
end
