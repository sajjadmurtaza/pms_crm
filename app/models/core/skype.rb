# == Schema Information
#
# Table name: core_skypes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  skype_type :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Core::Skype < ActiveRecord::Base
  audited
end
