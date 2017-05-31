# == Schema Information
#
# Table name: core_system_users
#
#  id                           :integer          not null, primary key
#  first_name                   :string(255)      not null
#  last_name                    :string(255)      not null
#  username                     :string(255)
#  email                        :string(255)
#  crypted_password             :string(255)
#  salt                         :string(255)
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#  auth_mode                    :string(255)
#  time_zone                    :string(255)
#  type                         :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  last_login_at                :string(255)
#  phone                        :string(255)
#  theme                        :string(255)
#
# Indexes
#
#  index_core_system_users_on_email              (email)
#  index_core_system_users_on_remember_me_token  (remember_me_token)
#  index_core_system_users_on_type               (type)
#

require 'test_helper'

class Directory::UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
