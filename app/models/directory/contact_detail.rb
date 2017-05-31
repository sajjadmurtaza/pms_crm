# == Schema Information
#
# Table name: directory_contact_details
#
#  id            :integer          not null, primary key
#  nick_name     :string(255)
#  company_title :string(255)
#  company_email :string(255)
#  company_phone :string(255)
#  contact_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  skype         :string(255)
#

class Directory::ContactDetail < ActiveRecord::Base
  audited only: [:nick_name, :company_title, :company_email, :company_phone], on: [:create, :update, :destroy]
  belongs_to :contact
end
