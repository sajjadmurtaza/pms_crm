# == Schema Information
#
# Table name: directory_accounts
#
#  id             :integer          not null, primary key
#  account_number :string(255)
#  title          :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Directory::Account < ActiveRecord::Base
  validates :account_number,:title, presence: true

  has_many :emails, class_name: 'Core::Email', as: :emailable
  has_many :billing_address, -> { where("core_addresses.address_type = 'billing'") }, class_name: 'Core::Address', as: :addressable
  has_many :postal_address, -> { where("core_addresses.address_type = 'postal'") }, class_name: 'Core::Address', as: :addressable

  accepts_nested_attributes_for :emails, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :billing_address, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :postal_address, reject_if: :all_blank, allow_destroy: true

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        id: id,
        title: title ,
        account_number: account_number,
        email: emails.first.email.present? ? emails.first.email : '',
        sort_title: title,
    }
  end

  def self.filter_options
    {
        sorting: [
            {key: :sort_title, label: 'Title'}
        ],
        filter_box: [
            {key: :title, label: 'Title'},
            {key: :account_number, label: 'Account Number'},
            {key: :email, label: 'Email'},
        ],
        filter_aggregates: [ ]
    }
  end
  #-----------------------------------------------------

  # Mappings
  # ------------------------------------------------------
  settings do
    mapping dynamic: true do
      [:sort_title].each do |attr|
        indexes attr, type: 'string', index: :not_analyzed
      end
    end
  end
  # ------------------------------------------------------

  def as_json(options= {})
    {id: self.id, text: self.title}
  end

end
