# == Schema Information
#
# Table name: pms_task_lists
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  taskable_id   :integer
#  taskable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  billable      :boolean          default(FALSE)
#

class Pms::TaskList < ActiveRecord::Base
  audited

  validates :title, presence: true
  belongs_to :taskable, polymorphic: true
  has_many :tasks, dependent: :destroy
  has_one :invoice, class_name: 'Core::Invoice'

  def complete_tasks
   self.tasks.where('completed = ?', true)
  end

  def incomplete_tasks
    self.tasks.where('completed = ?', false)
  end

  def taskable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

end
