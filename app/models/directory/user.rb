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

class Directory::User < Core::SystemUser
  include Noteable
  has_associated_audits

  before_save :encrypt_password

  attr_accessor :password, :password_confirmation,:old_password

  validates :password, presence: true, confirmation: true, length: {minimum: 5}, if: :new_record?
  validates :password, :confirmation => true,:length => {minimum: 5},:allow_blank => true, :on => :update
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  has_one :user_detail, dependent: :destroy, autosave: true
  delegate :emp_id, :emp_id=, :experience,:experience=, :education, :education=, :primary_role_id, :primary_role_id=,
           :secondary_roles, :secondary_roles=, :calling_name, :calling_name=,
           :summery, :summery=, :the_most_amazing, :the_most_amazing=,
           :perfered_development_environment, :perfered_development_environment=,
           :appointment_date, :appointment_date=, :organization_unit_id, :organization_unit_id=,
           :job_title_id, :job_title_id=, :location_id, :location_id=, to: :user_detail

  has_many :emails, class_name: 'Core::Email', as: :emailable, autosave: true
  has_many :phones, class_name: 'Core::Phone', as: :phoneable, autosave: true
  has_many :addresses, class_name: 'Core::Address', as: :addressable, autosave: true
  has_many :skypes, class_name: 'Core::Skype', as: :addressable, autosave: true
  has_many :projects, class_name: 'Core::PortfolioItem', as: :portfolioable, autosave: true


  has_many :created_projects, class_name: 'Pms::Project'

  has_many :projects_users, class_name: 'Pms::ProjectsUser'
  has_many :assigned_projects, through: :projects_users, source: :project

  has_many :tasks_users, class_name: 'Pms::TasksUser'
  has_many :assigned_tasks, through: :tasks_users, source: :task

  has_many :skills_users, dependent: :destroy, autosave: true
  has_many :skills, through: :skills_users, :class_name => 'Core::Skill'



  #has_many :secondary_roles_assigns, class_name: 'Directory::Role', dependent: destroy, autosave: true
  #has_many :secondary_roles, through: :secondary_roles_assigns, class_name: 'Directory::Role', autosave: true


  accepts_nested_attributes_for :emails, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :projects, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :skills_users, reject_if:  proc { |attributes| attributes['skill_id'].blank? }, allow_destroy: true
  #accepts_nested_attributes_for :skills, allow_destroy: true



  #acts_as_taggable_on :skills
  #accepts_nested_attributes_for :taggings , reject_if: :all_blank, allow_destroy: true

  def self.current
    Directory::User.new
  end

  def status_name
    STATUSES.keys[self.status].to_s
  end

  def active?
    self.status == STATUSES[:active]
  end

  def registered?
    self.status == STATUSES[:registered]
  end

  def locked?
    self.status == STATUSES[:locked]
  end

  #def must_change_password?
  #  false
  #end

  def password_matched?(old_password)
    return true if self.crypted_password == BCrypt::Engine.hash_secret(old_password, self.salt)
    false
  end

  def logged?
    true
  end

  def admin?
    true
  end
  def allowed_to?(url)
    true
  end

  def get_secondary_roles
    roles = []
    role_ids = []
    role_ids = self.secondary_roles.split(',') unless secondary_roles.nil?
    role_ids.each do |role_id|
      roles.push Directory::Role.find(role_id)
    end
    roles
  end

  def get_secondary_roles_options(role_id)
    roles = []
    Directory::Role.all.each do |role|
      roles.push role unless role.id == role_id
    end
    roles
  end

  #def create_new_taggings(user_taggings)
  #  user_taggings.each do |user_tagging|
  #    if user_tagging[1][:tag_id].to_i == 0
  #      tag = ActsAsTaggableOn::Tag.new name: user_tagging[1][:tag_id]
  #      tag.save
  #      user_tagging[1][:tag_id] = tag.id
  #    end
  #  end
  #end

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        id: id,
        name: [first_name, last_name, username],
        email: email,
        phones: phones.pluck(:phone),
        addresses: addresses.map(&:to_s),
        skills: skills.pluck(:id) || [],
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
            {key: :skills, label: 'Skills', collection: Core::Skill.all.inject({}) { |h, t| h[t.id.to_s] = t.name; h }}
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

end
