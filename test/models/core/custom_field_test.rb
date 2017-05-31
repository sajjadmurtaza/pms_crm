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

require 'test_helper'

class Core::CustomFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
