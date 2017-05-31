# == Schema Information
#
# Table name: core_notes
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notable_id      :integer
#  notable_type    :string(255)
#  content         :text
#  note_fields     :text
#  note_attachment :string(255)
#  note_type_id    :integer
#  created_at      :datetime
#  updated_at      :datetime
#  note_id         :integer
#

class Core::Note < ActiveRecord::Base

  audited

  # acts_as_commentable class_name: 'Core::Comment'

  belongs_to :notable, polymorphic: true
  belongs_to :note_type, :class_name => 'Core::NoteType'
  belongs_to :user, :class_name => 'Directory::User'
  belongs_to :note, :class_name => "Core::Note"
  has_many :comments, :class_name => "Core::Note", :foreign_key => "note_id"
  has_many :attachments, as: :fileable, class_name: 'Attachment'
  has_many :custom_values, :class_name => 'Core::CustomValue', as: :customized, dependent: :destroy
  has_many :custom_fields, :class_name => 'Core::CustomField', through: :custom_values
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :custom_values, reject_if: :all_blank, allow_destroy: true
  validates :notable_type, presence: true
  validates :notable_id, presence: true
  validates :note_type_id, presence: true

  serialize :note_fields, Hash

  def build_for_editing
    custom_field_ids = custom_values.pluck(:custom_field_id)
    note_type.custom_fields.each do |field|
      custom_values.build(custom_field: field) unless custom_field_ids.include? field.id
    end
  end

  def note_type
    (note_type_id == 0 || note_type_id == "0") ? (Core::NoteType.new id: 0, name: "Comment") : super
  end

  def notable_name
    return notable.title if notable_type == 'Pms::Project' and notable
    return notable.name if notable_type == 'Crm::Lead' and notable
    return nil
  end

  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        id: id,
        note_type: note_type.name.gsub(' ',''),
        note_type_id: note_type.id,
        content: content,
        notable_id: notable_id,
        notable_type: notable_type,
        user: [user.first_name, user.last_name, user.username],
        notable_name: notable_name,
        created_date: created_at.strftime("%Y-%m-%d")
    }
  end

  def self.filter_options
    {
        filter_box: [
            {key: :note_type, label: 'Note Type'},
            {key: :user, label: 'Posted By'},
            {key: :content, label: 'Text Content'}   

        ],
        filter_aggregates: [
          {key: :note_type, label: 'Note Type', collection: (Core::NoteType.all.inject({}) { |h, t| h[t.name.downcase.gsub(' ','')] = t.name.titleize; h }).merge({"comment"=>"Comment"})}
        ]
    }
  end
  #-----------------------------------------------------

end
