# == Schema Information
#
# Table name: core_phones
#
#  id             :integer          not null, primary key
#  phone          :string(255)
#  phone_type     :string(255)
#  phoneable_id   :integer
#  phoneable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Core::Phone < ActiveRecord::Base
  belongs_to :phoneable, polymorphic: true
  audited only: [:phone, :phone_type], on: [:create, :update, :destroy], associated_with: :phoneable

  def to_s
    phone.to_s
  end

end
