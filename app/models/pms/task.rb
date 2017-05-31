# == Schema Information
#
# Table name: pms_tasks
#
#  id           :integer          not null, primary key
#  description  :text
#  task_list_id :integer
#  user_id      :integer
#  due_date     :date
#  completed    :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

class Pms::Task < ActiveRecord::Base
  audited

  acts_as_commentable class_name: 'Core::Comment'

  belongs_to :user, class_name: 'Directory::User'
  belongs_to :task_list, class_name: 'Pms::TaskList'

  validates :description, :task_list_id, :user_id, :due_date, presence: true

  has_many :tasks_users, class_name: 'Pms::TasksUser'
  has_many :assigned_users, through: :tasks_users, source: :user
  has_many :attachments, as: :fileable, class_name: 'Attachment'

  accepts_nested_attributes_for :tasks_users, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  has_one :calendar_entry, :class_name => 'Workspace::CalendarEntry', as: :reference, dependent: :destroy
  after_create :setup_calender_entries
  after_update :update_calender_entries

  def setup_calender_entries
    entry = self.build_calendar_entry
    entry.title = self.description.length > 255 ? self.description[0..50].html_safe : self.description
    entry.start_date = self.due_date
    entry.end_date = self.due_date
    entry.calendar = self.task_list.taskable.calendar
    entry.save
  end

  def update_calender_entries
    setup_calender_entries unless self.calendar_entry
    if self.changed? or self.calendar_entry.new_record?
      self.calendar_entry.title = self.description.length > 255 ? self.description[0..50].html_safe : self.description
      self.calendar_entry.start_date = self.due_date
      self.calendar_entry.end_date = self.due_date
      self.calendar_entry.calendar = self.task_list.taskable.calendar
      self.calendar_entry.save
    end
  end

  def project
    ((task_list and task_list.taskable_type == "Pms::Project") ? task_list.taskable : nil)
  end

  def user_name
    user ? [user.first_name, user.last_name, user.username] : []
  end
  # Search methods
  #----------------------------------------------------
  include ElasticsearchSearchable

  def as_indexed_json(options={})
    {
        description: description,
        user: user_name,
        project: (project ? project.title : nil),
        created_date: created_at.strftime("%Y-%m-%d")
    }
  end

  def self.filter_options
    {
        filter_box: [

        ],
        filter_aggregates: [

        ]
    }
  end
  #-----------------------------------------------------
end
