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

require 'test_helper'

class Core::PortfolioItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
