module Heyday::AuthManager::AuthMode
  class Base

    def initialize
      raise_error
    end

    def auth_mode_name
      raise_error
    end

    def authenticate(username, password)
      raise_error
    end

    protected
    def raise_error
      raise RuntimeError.new("You must extend Heyday::AuthManager::AuthMode::Base to use in authentication.")
    end
  end
end

