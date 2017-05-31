# == Schema Information
#
# Table name: crm_leads
#
#  id                   :integer          not null, primary key
#  email                :string(255)
#  skype                :string(255)
#  technology           :string(255)
#  source_id            :integer
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  state                :string(255)
#  user_id              :integer
#  phone                :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  organization_unit_id :integer
#
# Indexes
#
#  index_crm_leads_on_state    (state)
#  index_crm_leads_on_user_id  (user_id)
#

class Crm::Lead < ActiveRecord::Base
  include Noteable
  audited
  validates_presence_of :first_name, :last_name, :email
  belongs_to :source, class_name: 'Core::Source'
  belongs_to :user, :class_name => 'Core::SystemUser'
  acts_as_taggable_on :technologies

  belongs_to :organization_unit, :class_name => 'Core::OrganizationUnit'

  has_many :leads_contacts, class_name: 'Crm::LeadsContact', dependent: :destroy
  has_many :assigned_contacts, through: :leads_contacts, source: :contact
  has_many :invoices, class_name: 'Core::Invoice', dependent: :destroy
  has_many :quotes, class_name: 'Core::Quote', dependent: :destroy
  has_one :project, class_name: 'Pms::Project'
  has_many :attachments, as: :fileable, class_name: 'Attachment'

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :taggings , reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :source , reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :leads_contacts, :reject_if => :all_blank, :allow_destroy => true

  # Calendar Entry Methods methods
  #----------------------------------------------------
  def calendar_entry_title
    "#{first_name} #{last_name}"
  end

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        id: id,
        name: [first_name, last_name],
        email: email,
        description: description,
        technologies: technologies.pluck(:id) || [],
        source_id: source_id,
        status: self.send(self.class.state_column),
        organization_unit_id: self.organization_unit_id,
        sort_name: "#{first_name} #{last_name}",
        sort_email: email,
        created_date: created_at.strftime("%Y-%m-%d")
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
            {key: :email, label: 'Email'}
        ],
        filter_aggregates: [
            {key: :status, label: 'Status', collection: Crm::Lead.new.workflow.states.inject({}) { |h, t| h[t] = t; h }},
            {key: :organization_unit_id, label: 'Service', collection: Core::OrganizationUnit.all.inject({}) { |h, t| h[t.id.to_s] = t.title; h }},
            {key: :technologies, label: 'Technology', collection: Crm::Lead.tag_counts_on(:technologies).inject({}) { |h, t| h[t.id.to_s] = t.name; h }},
            {key: :source_id, label: 'Source', collection: Core::Source.all.inject({}) { |h, t| h[t.id.to_s] = t.name; h }}

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

  # Workflow methods
  #----------------------------------------------------
  include Heyday::Workflow::DataEntity
  workflow workflow_class: 'LeadWorkflow', state_column: 'state'
  #----------------------------------------------------

  def create_new_taggings(lead_taggings)
    lead_taggings.each do |lead_tagging|
      if lead_tagging[1][:tag_id].to_i == 0
        tag = ActsAsTaggableOn::Tag.new name: lead_tagging[1][:tag_id]
        tag.save
        lead_tagging[1][:tag_id] = tag.id
      end
    end
  end

  def as_json(options= {})
    {id: self.id, text: self.name}
  end

  def name
    "#{first_name} #{last_name}"
  end
end
