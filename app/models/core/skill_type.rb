# == Schema Information
#
# Table name: core_enumerations
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  value      :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class Core::SkillType <  Core::Enumeration
  has_many :skills, :class_name => 'Core::Skill'
end
