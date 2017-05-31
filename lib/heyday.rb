# Auth Manager
require 'heyday/menu_manager'
require 'heyday/hooks'

# Auth Manager
require 'heyday/auth_manager'
require 'heyday/auth_manager/auth_mode/base'
require 'heyday/auth_manager/auth_mode/basic'
require 'heyday/auth_manager/auth_controller'
require 'bcrypt'
Heyday::AuthManager.register :basic

# Registering ldap and its config values
Core::Setting.create_setting 'ldap_config',
                             {
                                 'serialized' => true,
                                 'default' => {
                                     'host' => '127.0.0.1',
                                     'port' => '389',
                                     'base' => 'dc=test,dc=com',
                                     'ou' => 'nextbridge',
                                     'cn' => 'ldap_group',
                                     'login_attr' => 'cn',
                                     'group_attr' => 'cn',
                                     'orgunit_attr' => 'ou',
                                     'fullname_attr' => 'displayName',
                                     'email_attr' => 'mail'
                                 }}
Core::Setting.create_setting_accessors :ldap_config
Heyday::AuthManager.register :ldap

# Workflow Manager
require 'heyday/workflow'
require 'heyday/workflow/base'
require 'heyday/workflow/data_entity'
