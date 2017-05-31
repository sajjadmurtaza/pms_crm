# == Schema Information
#
# Table name: directory_contact_directories
#
#  id             :integer          not null, primary key
#  directory_name :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Directory::ContactDirectory < ActiveRecord::Base
  audited
  has_many :contact_details
  has_many :contacts, through: :contact_details

  validates :directory_name, :presence => true

  def to_s
    directory_name
  end
end
