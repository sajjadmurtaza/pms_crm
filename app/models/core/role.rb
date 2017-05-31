# == Schema Information
#
# Table name: core_roles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Core::Role < ActiveRecord::Base
  audited
  has_many :user_details, class_name: 'Directory::UserDetail'

  def as_json(options= {})
    {id: self.id, text: self.name}
  end

  validates :name, presence: true, uniqueness: true
end
