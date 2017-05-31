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

class Core::Quote < ActiveRecord::Base

  DEFAULT_STATUS = 'Sent'
  #belongs_to :reference, class_name: 'Core::Quote', polymorphic: true
  belongs_to :lead, class_name: 'Crm::Lead'
  belongs_to :project, class_name: 'Pms::Project'
  belongs_to :status, class_name: 'Core::QuoteStatus'

  has_many :attachments, as: :fileable, class_name: 'Attachment'
  belongs_to :invoice_split, class_name: 'Core::InvoiceSplit'

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

end
