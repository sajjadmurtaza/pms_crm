module Heyday
  class AuthModeError < StandardError
    attr_reader :auth_mode_id
    def initialize(auth_mode_id=nil)
      super
      @auth_mode_id = auth_mode_id
    end
  end

  class AuthModeNotFound < AuthModeError
    def to_s
      "Missing the Mode '#{@auth_mode_id}'. Please Contact Your System Admin."
    end
  end

  module AuthManager
    mattr_accessor :registered_modes

    def self.registered_modes
      @registered_modes ||= ActiveSupport::OrderedHash.new
    end

    # AuthMode constructor
    def self.register(id, mode_klass=nil)
      mode_klass = "Heyday::AuthManager::AuthMode::#{id.to_s.capitalize}".constantize if mode_klass.nil?
      self.registered_modes[id] = mode_klass
    end

    # Returns an array of all registered authentication modes
    def self.all
      self.registered_modes.values
    end

    # Finds a authentication mode by its id
    # Returns a AuthModeNotFound exception if the mode doesn't exist
    def self.find(id)
      self.registered_modes[id] || raise(AuthModeNotFound.new(id.to_s.to_sym))
    end

    # Clears the registered Authentication Modes hash
    # It doesn't unload installed auth modes
    def self.clear
      self.registered_modes = {}
    end

    # Checks if a AuthMode is installed
    #
    # @param [String] id name of the authentication mode
    def self.installed?(id)
      self.registered_modes[id.to_sym].present?
    end

    def <=>(mode)
      self.id.to_s <=> mode.id.to_s
    end
  end
end