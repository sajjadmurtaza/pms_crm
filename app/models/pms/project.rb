# == Schema Information
#
# Table name: pms_projects
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :text
#  start_date       :date
#  end_date         :date
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  account_id       :integer
#  manager_id       :integer
#  planned_end_date :date
#  cost             :float
#  status_id        :integer
#  percentage_done  :integer
#  lead_id          :integer
#

class Pms::Project < ActiveRecord::Base
  audited

  include Noteable

  validates :title, presence: true

  belongs_to :status, class_name: 'Core::Status'

  belongs_to :user, class_name: Directory::User
  has_many :projects_users, class_name: 'Pms::ProjectsUser', dependent: :destroy
  has_many :assigned_users, through: :projects_users, source: :user

  has_many :projects_contacts, class_name: 'Pms::ProjectsContact', dependent: :destroy
  has_many :assigned_contacts, through: :projects_contacts, source: :contact
  has_many :invoices, class_name: 'Core::Invoice'
  has_many :quotes, class_name: 'Core::Quote'

  belongs_to :account, class_name: 'Directory::Account'
  belongs_to :manager, class_name: 'Directory::User'
  belongs_to :lead, class_name: 'Crm::Lead'

  has_many :task_lists, as: :taskable
  has_many :attachments, as: :fileable, class_name: 'Attachment'

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :projects_users, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :projects_contacts, :reject_if => :all_blank, :allow_destroy => true

  has_one :calendar, :class_name => 'Workspace::Calendar', as: :reference, dependent: :destroy
  after_create :setup_calender, :import_lead_data
  after_update :update_calendar
  after_destroy :remove_calendar

  def setup_calender
    colors = %w(#d1b391 #f15f74 #a9b0b0 #a0cdb3 #e66967 #f28e5a #69a3d2 #efdd78)
    cal = self.build_calendar
    cal.name = "#{self.title} Project"
    cal.color = colors.sample
    cal.user = self.user
    cal.save
  end

  def import_lead_data
    if self.lead
      self.invoices << self.lead.invoices
      self.quotes << self.lead.quotes
    end
  end

  def update_calendar
    setup_calender unless self.calendar
    self.calendar.name = "#{self.title} Project"
    self.calendar.save
  end

  def remove_calendar
    calendar = Workspace::Calendar.where(reference: self).first
    calendar.destroy if calendar
  end

  def calendar_entry_title
    "#{title}"
  end

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        id: id,
        title: title,
        description: description,
        sort_title: title,
        start_date: start_date.present? ? "#{start_date}" : ''
    }
  end

  def self.filter_options
    {
        sorting: [
            {key: :sort_title, label: 'Title'},
            {key: :start_date, label: 'Start Date'}
        ],
        filter_box: [
            {key: :title, label: 'Title'},
            {key: :description, label: 'Description'},
        ],
        filter_aggregates: [
        ]
    }
  end
  #-----------------------------------------------------

  # Mappings
  # ------------------------------------------------------
  settings do
    mapping dynamic: true do
      [:sort_title, :start_date].each do |attr|
        indexes attr, type: 'string', index: :not_analyzed
      end
    end
  end
  # --------------------------------------------------------
end
