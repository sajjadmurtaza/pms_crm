module Heyday::AuthManager::AuthMode
  #require 'net/ldap/dn'
  #require 'net/http'
  #require 'openssl'
  class Ldap < Base
    require 'net/ldap'

    def initialize(username, password)
      @username = username
      @password = password
      @config = Core::Setting.ldap_config
    end

    def self.auth_mode_name
      'ldap'
    end

    def authenticate
      puts 'In Auth Mode Ldap'
      raise ArgumentError, 'username is nil' if @username.nil? or @username.blank?
      raise ArgumentError, 'password is nil' if @password.nil? or @password.blank?

      ldap = Net::LDAP.new  :host => @config['host'],
                            :port => @config['port'],
                            :base => @config['base'],
                            :auth => {
                                :method => :simple,
                                :username => "#{@config['login_attr']}=#{@username},#{@config['group_attr']}=#{@config['cn']},#{@config['orgunit_attr']}=#{@config['ou']},#{@config['base']}",
                                :password => @password
                            }

      bound = ldap.bind

      if bound
        puts "Connection successful!  Code:  #{ldap.get_operation_result.code}, message: #{ldap.get_operation_result.message}"
        user = Directory::User.find_by_username @username
        if user
          return user.id
        else
          base   = @config['base']
          filter = Net::LDAP::Filter.eq(@config['login_attr'], @username)
          attrs = "#{@config['fullname_attr']} #{@config['email_attr']}"
          ldap.search(:base => base, :filter => filter, :attributes => attrs.split(' '), :return_result => true) do |entry|
            auth_mode = Ldap.auth_mode_name
            display_name = entry.send(@config['fullname_attr']).first
            first_name = display_name.split(' ')[0] rescue ''
            last_name = display_name.split(' ')[1] rescue ''
            email = entry.send(@config['email_attr']).first rescue ''
            puts 'before user params'
            user_params = {:first_name => first_name, :last_name => last_name,
                           :email => email, :username => @username,
                           :password => @password, :password_confirmation => @password,
                           :auth_mode => auth_mode }
            puts 'after params'
            puts user_params
            user = register_user(user_params)

            return user.id if user
          end
        end
      else
        puts "Connection failed!  Code:  #{ldap.get_operation_result.code}, message: #{ldap.get_operation_result.message}"
      end
      bound
    end

    def register_user(params)
      user = Directory::User.new params
      if user.save
        return user
      end
    end

  end
end