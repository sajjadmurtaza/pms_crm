# == Schema Information
#
# Table name: core_emails
#
#  id             :integer          not null, primary key
#  email          :string(255)
#  email_type     :string(255)
#  emailable_id   :integer
#  emailable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Core::Email < ActiveRecord::Base
  #audited only: [:email, :email_type], on: [:create, :update, :destroy]
  belongs_to :emailable, polymorphic: true
  audited only: [:email, :email_type], on: [:create, :update, :destroy], associated_with: :emailable
end
