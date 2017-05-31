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

class Directory::Contact < Core::SystemUser
  include Noteable
  has_associated_audits

  has_one :contact_detail, dependent: :destroy, :autosave => true
  delegate :nick_name, :nick_name=, :skype, :skype=, :company_title, :company_title=, :company_email, :company_email=, :company_phone, :company_phone=, to: :contact_detail

  has_many :emails, class_name: 'Core::Email', as: :emailable
  has_many :phones, class_name: 'Core::Phone', as: :phoneable
  has_many :addresses, class_name: 'Core::Address', as: :addressable
  #has_many :skypes, class_name: 'Core::Skype', as: :addressable

  has_many :projects_contacts, class_name: 'Pms::ProjectsContact', dependent: :destroy
  has_many :assigned_projects, through: :projects_contacts, source: :project

  has_many :leads_contacts, class_name: 'Crm::LeadsContact', dependent: :destroy
  has_many :assigned_leads, through: :leads_contacts, source: :lead

  accepts_nested_attributes_for :emails, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

  acts_as_taggable_on :directories

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        id: id,
        name: [first_name, last_name, nick_name],
        email: email,
        phones: phones.pluck(:phone),
        addresses: addresses.map(&:to_s),
        directories: directories.pluck(:id) || [],
        created_at: created_at,
        updated_at: updated_at,
        sort_name: "#{first_name} #{last_name}",
        sort_email: email
    }
  end

  def self.filter_options
    {
        sorting: [
            {key: :sort_name, label: 'Name'},
            {key: :sort_email, label: 'Email'}
        ],
        filter_box: [
            {key: :name, label: 'Name'},
            {key: :email, label: 'Email'},
            {key: :phones, label: 'Phones'},
            {key: :addresses, label: 'Address'},
        ],
        filter_aggregates: [
            {key: :directories, label: 'Directories', collection: Directory::Contact.tag_counts_on(:directories).inject({}) { |h, t| h[t.id.to_s] = t.name; h }}
        ]
    }
  end
  #-----------------------------------------------------

  # Mappings
  # ------------------------------------------------------
  settings do
    mapping dynamic: true do
      [:sort_name, :sort_email].each do |attr|
        indexes attr, type: 'string', index: :not_analyzed
      end
    end
  end
  # ------------------------------------------------------

  def to_s
    "#{self.first_name} #{self.last_name}"
  end

end

