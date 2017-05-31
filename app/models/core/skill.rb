# == Schema Information
#
# Table name: core_skills
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  skill_type_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Core::Skill < ActiveRecord::Base
  attr_accessor :rating
  has_many :skills_users
  has_many :users, through: :skills_users, :class_name => 'Directory::User'
  belongs_to :skill_type, :class_name => 'Core::SkillType'
  accepts_nested_attributes_for :skills_users, reject_if: :all_blank, allow_destroy: true
  validates :name, :skill_type_id, presence: true

  def as_json(options={})
    { id: id, text: name }
  end
end
