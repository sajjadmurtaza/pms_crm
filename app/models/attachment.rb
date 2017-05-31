# == Schema Information
#
# Table name: attachments
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  fileable_id   :integer
#  fileable_type :string(255)
#
#require 'file_mime_type_validator'
class Attachment < ActiveRecord::Base
  belongs_to :fileable, polymorphic: true
  audited only: [:name], on: [:create, :update, :destroy], associated_with: :fileable

  mount_uploader :name, FileUploader

#validates :name,
#            file_mime_type: {
#              content_type: /image|octet-stream/, message: 'Only image is required!'
#            }

end
