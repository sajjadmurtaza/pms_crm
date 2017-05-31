# == Schema Information
#
# Table name: core_system_users
#
#  id                           :integer          not null, primary key
#  first_name                   :string(255)      not null
#  last_name                    :string(255)      not null
#  username                     :string(255)
#  email                        :string(255)
#  crypted_password             :string(255)
#  salt                         :string(255)
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#  auth_mode                    :string(255)
#  time_zone                    :string(255)
#  type                         :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  last_login_at                :string(255)
#  phone                        :string(255)
#  theme                        :string(255)
#
# Indexes
#
#  index_core_system_users_on_email              (email)
#  index_core_system_users_on_remember_me_token  (remember_me_token)
#  index_core_system_users_on_type               (type)
#

require 'bcrypt'
require 'RMagick'
include Magick
class Core::SystemUser < ActiveRecord::Base
  cattr_accessor :current
  audited only: [:first_name, :last_name, :username, :email], on: [:create, :update, :destroy]
  has_many :calendars, class_name: 'Workspace::Calendar'
  has_one :picture, as: :fileable, class_name: 'Attachment'
  has_many :calendars_users, class_name: 'Workspace::CalendarsUser', dependent: :destroy
  has_many :shared_calendars, through: :calendars_users, class_name: 'Workspace::Calendar', source: :calendar

  validates_presence_of :first_name, :last_name
  accepts_nested_attributes_for :picture, reject_if: :all_blank, allow_destroy: true
  # Account statuses
  # Code accessing the keys assumes they are ordered, which they are since Ruby 1.9
  STATUSES = {
      :builtin => 0,
      :active => 1,
      :registered => 2,
      :locked => 3
  }
  DEFAULT_PICTURE_NAME = 'heyday_default_picture.jpg'

  USER_FORMATS_STRUCTURE = {
      :first_last => [:first_name, :last_name],
      :first => [:first_name],
      :last_first => [:last_name, :first_name],
      :last_coma_first => [:last_name, :first_name],
      :username => [:username]
  }

  def self.user_format_structure_to_format(key, delimiter = " ")
    USER_FORMATS_STRUCTURE[key].map { |elem| "\#{#{elem.to_s}}" }.join(delimiter)
  end

  USER_FORMATS = {
      :first_last => Core::SystemUser.user_format_structure_to_format(:first_last, " "),
      :first => Core::SystemUser.user_format_structure_to_format(:first),
      :last_first => Core::SystemUser.user_format_structure_to_format(:last_first, " "),
      :last_coma_first => Core::SystemUser.user_format_structure_to_format(:last_coma_first, ", "),
      :username => Core::SystemUser.user_format_structure_to_format(:username)
  }

  # Return user's full name for display
  def name(formatter = :first_last)
    if formatter
      eval('"' + (USER_FORMATS[formatter] || USER_FORMATS[:first_name_last_name]) + '"')
    else
      @name ||= eval('"' + (USER_FORMATS[Setting.user_format] || USER_FORMATS[:first_name_last_name]) + '"')
    end
  end


  def self.find_by_username(username)
    if username.present?
      # First look for an exact match
      user = where(:username => username).detect { |u| u.username == username }
      unless user
        # Fail over to case-insensitive if none was found
        user = where("LOWER(username) = ?", username.downcase).first
      end
      user
    end
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.crypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def set_default_picture
    colors = %w(#d1b391 #f15f74 #a9b0b0 #a0cdb3 #e66967 #f28e5a #69a3d2 #efdd78)

    img = Image.new(200,200) { self.background_color = colors.sample }
     Draw.new.annotate(img, 200,200,35, 90, self.name.split(' ').first) {
      self.font = "#{Rails.root}/app/assets/fonts/GloriaHallelujah.ttf"
      self.font_family = 'Gloria Hallelujah'
      self.fill = 'white'
      self.stroke = 'transparent'
      self.pointsize = 80
      self.font_weight = BoldWeight
    }
    Draw.new.annotate(img, 200,200, 50, 170, self.name.split(' ').last) {
      self.font = "#{Rails.root}/app/assets/fonts/GloriaHallelujah.ttf"
      self.font_family = 'Gloria Hallelujah'
      self.fill = 'white'
      self.stroke = 'transparent'
      self.pointsize = 80
      self.font_weight = BoldWeight
    }

    file_path = "#{Rails.root}/public/default_picture/#{DEFAULT_PICTURE_NAME}"
    img.write file_path
    picture = self.build_picture
    picture.name = File.open(file_path)
    picture.save
  end

  def as_json(options= {})
    {id: self.id, text: self.name}
  end

end
