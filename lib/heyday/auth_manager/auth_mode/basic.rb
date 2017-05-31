module Heyday::AuthManager::AuthMode
  class Basic < Base

    def initialize(username, password)
      @username = username
      @password = password
    end

    def auth_mode_name
      'Basic'
    end

    def authenticate
      puts "In Auth Mode Basic"
      user = Core::SystemUser.find_by_username(@username)
      if user && user.crypted_password == BCrypt::Engine.hash_secret(@password, user.salt)
        user.id
      else
        return nil
      end
    end
  end
end