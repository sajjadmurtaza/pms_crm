# == Schema Information
#
# Table name: core_addresses
#
#  id               :integer          not null, primary key
#  address1         :string(255)
#  address2         :string(255)
#  address_type     :string(255)
#  city             :string(255)
#  zip              :string(255)
#  state            :string(255)
#  country          :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Core::Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  audited only: [:address1, :address2, :city, :zip, :state, :country], on: [:create, :update, :destroy], associated_with: :addressable
  belongs_to :directory_account, :class_name => 'Directory::Account'

  def to_s
    "#{city}, #{zip}"
  end

end
