# == Schema Information
#
# Table name: core_invoices
#
#  id                   :integer          not null, primary key
#  due_date             :date
#  organization_unit_id :integer
#  invoice_project      :text
#  invoice_task         :text
#  cost                 :float
#  split_type_id        :integer
#  reference_id         :integer
#  reference_type       :string(255)
#  project_id           :integer
#  lead_id              :integer
#  created_at           :datetime
#  updated_at           :datetime
#  status_id            :integer
#  user_id              :integer
#  task_list_id         :integer
#

require 'test_helper'

class Core::InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
