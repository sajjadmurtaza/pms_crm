# == Schema Information
#
# Table name: skills_users
#
#  id              :integer          not null, primary key
#  rating          :string(255)
#  experience      :integer
#  show_on_profile :integer
#  user_id         :integer
#  skill_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class SkillsUser < ActiveRecord::Base
  belongs_to :skill, :class_name => 'Core::Skill'
  belongs_to :user, :class_name => 'Directory::User'
  validates :experience, numericality: {only_integer: true, greater_than_or_equal_to: 1 }
end
