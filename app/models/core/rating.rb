# == Schema Information
#
# Table name: core_ratings
#
#  id            :integer          not null, primary key
#  value         :float
#  rateable_id   :integer
#  rateable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Core::Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true
  audited only: [:value], on: [:create, :update, :destroy], associated_with: :rateable

  validates :value, presence:true

  RATING_VALUES = [
      'Exceptional',
      'Excellent',
      'Average',
      'Bad',
      'Poor'
  ]

end
