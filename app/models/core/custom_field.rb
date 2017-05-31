# == Schema Information
#
# Table name: core_custom_fields
#
#  id              :integer          not null, primary key
#  type            :string(30)       default(""), not null
#  field_format    :string(30)       default(""), not null
#  regexp          :string(255)      default("")
#  min_length      :integer          default(0), not null
#  max_length      :integer          default(0), not null
#  required        :boolean          default(FALSE)
#  editable        :boolean          default(TRUE)
#  searchable      :boolean          default(FALSE)
#  scheduleable    :boolean          default(FALSE)
#  name            :string(255)      not null
#  default_value   :text
#  possible_values :text
#  position        :integer          default(0)
#  meta            :text
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_core_custom_fields_on_type  (type)
#

class Core::CustomField < ActiveRecord::Base
  FIELD_FORMATS = %w(string text int float list date bool)
  serialize :possible_values
  has_many :values, :class_name => 'Core::CustomValue', dependent: :destroy
  validates_inclusion_of :field_format, :in => FIELD_FORMATS
  validates_presence_of :name, :field_format

  before_validation :configure_values

  def configure_values
    self.searchable = false if %w(int float date bool).include?(self.field_format)
    self.scheduleable = false unless self.field_format == 'date'
    true
  end

  validate :validate_presence_of_possible_values

  def validate_presence_of_possible_values
    if self.field_format == "list"
      errors.add(:possible_values, :blank) if self.possible_values.blank?
      errors.add(:possible_values, :invalid) unless self.possible_values.is_a? Array
    end
  end

  def form_input_format
    {string: 'string', text: 'wysi', int: 'integer', float: 'float', list: 'select', date: 'date_time_picker', bool: 'boolean'}[self.field_format.to_sym]
  end
end
