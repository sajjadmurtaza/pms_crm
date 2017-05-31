# == Schema Information
#
# Table name: core_organization_units
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  ancestry   :string(255)
#
# Indexes
#
#  index_core_organization_units_on_ancestry  (ancestry)
#

class Core::OrganizationUnit < ActiveRecord::Base
  audited
  has_ancestry
  has_many :user_details, :class_name => 'Directory::UserDetail'
  has_one :lead, :class_name => 'Crm::Lead'

  validates :role, presence:true
  validates :title, presence:true

  def as_json(options={})
    if options.blank?
      { id: self.id, parentId: self.parent_id, Title: self.title, Role: self.role, Members:  'Members: '+self.count_members }
    else
      { id: self.id, parent:self.parent_id, text: self.title}
    end
  end

  def count_members
    @user_count= self.user_details.count
    self.descendants.each do |f|
      @user_count+= f.user_details.count
    end
    return @user_count.to_s
  end

  def title_for_selects
      "#{'-' * depth} #{title}"
  end

end
