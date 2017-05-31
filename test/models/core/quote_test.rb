# == Schema Information
#
# Table name: core_quotes
#
#  id               :integer          not null, primary key
#  amount           :float
#  description      :text
#  invoice_split_id :integer
#  quote_date       :date
#  project_id       :integer
#  lead_id          :integer
#  reference_id     :integer
#  reference_type   :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  status_id        :integer
#
# Indexes
#
#  index_core_quotes_on_reference_id_and_reference_type  (reference_id,reference_type)
#

require 'test_helper'

class Core::QuoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
