# == Schema Information
#
# Table name: core_invoices
#
#  id                   :integer          not null, primary key
#  due_date             :date
#  organization_unit_id :integer
#  invoice_project      :text
#  invoice_task         :text
#  cost                 :float
#  split_type_id        :integer
#  reference_id         :integer
#  reference_type       :string(255)
#  project_id           :integer
#  lead_id              :integer
#  created_at           :datetime
#  updated_at           :datetime
#  status_id            :integer
#  user_id              :integer
#  task_list_id         :integer
#

class Core::Invoice < ActiveRecord::Base

  audited except: [:project_id, :lead_id], on: [:update, :create]
  DEFAULT_STATUS = 'New Request'

  #belongs_to :reference, class_name: 'Core::Invoice', polymorphic: true
  belongs_to :lead, class_name: 'Crm::Lead'
  belongs_to :project, class_name: 'Pms::Project'
  belongs_to :split_type, class_name: 'Core::InvoiceSplitType'
  belongs_to :organization_unit, class_name:  'Core::OrganizationUnit'
  belongs_to :status, class_name: 'Core::InvoiceStatus'
  belongs_to :task_list, class_name: 'Pms::TaskList'
  belongs_to :user, class_name: 'Directory::User'

  has_one :calendar_entry, :class_name => 'Workspace::CalendarEntry', as: :reference, dependent: :destroy

  after_create :setup_calender_entries
  after_update :update_calender_entries
  before_destroy :remove_notes

  def setup_calender_entries
    entry = self.build_calendar_entry
    entry.title = "#{self.lead.present? ? self.lead.name : '-'} $#{self.cost} \n #{self.project.present? ? self.project.title : '-' }"
    entry.start_date = self.due_date
    entry.end_date = self.due_date
    entry.calendar = Workspace::Calendar.find_or_create_by(name: self.class.to_s.split('::').last.pluralize, system_user_id: Core::EmbeddedUser.find_by_username('system_user').id)
    if entry.calendar.new_record?
      entry.calendar.color =  '#839098'
      entry.calendar.save
    end
    entry.save
  end

  def update_calender_entries
    setup_calender_entries unless self.calendar_entry
    if self.changed? or self.calendar_entry.new_record?
      self.calendar_entry.title = "#{self.lead.present? ? self.lead.name : '-'} $#{self.cost} \n #{self.project.present? ? self.project.title : '-' }"
      self.calendar_entry.start_date = self.due_date
      self.calendar_entry.end_date = self.due_date
      self.calendar_entry.save
    end
  end

  def remove_notes
    Core::Note.destroy_all(notable: self)
  end

  # create elasticsearch index after audit

  def after_audit
    audit = Workspace::Audit.find_by_id(self.audits.last)
    audit.__elasticsearch__.index_document if audit
  end

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        id: id,
        invoice_project:  invoice_project,
        status_id: status_id,
        organization_unit_id: self.organization_unit_id,
        sort_project: "#{invoice_project}"
    }
  end



  def self.filter_options
    {
        sorting: [
            {key: :sort_project, label: 'Project'},
        ],
        filter_box: [
            # {key: :invoice_project, label: 'Project'},
        ],
        filter_aggregates: [
            {key: :organization_unit_id, label: 'Service', collection: Core::OrganizationUnit.all.inject({}) { |h, t| h[t.id.to_s] = t.title; h }},
            {key: :status_id, label: 'Status', collection: Core::InvoiceStatus.all.inject({}) { |h, t| h[t.id.to_s] = t.name; h }}

        ]
    }
  end

  #-----------------------------------------------------

  # Mappings
  # ------------------------------------------------------
  settings do
    mapping dynamic: true do
      [:sort_project].each do |attr|
        indexes attr, type: 'string', index: :not_analyzed
      end
    end
  end
  # ------------------------------------------------------

end
