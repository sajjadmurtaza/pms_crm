module Heyday
  module AuthManager
    module AuthController
      extend ActiveSupport::Concern

      included do
      end

      def login(username, password)
        user = Core::SystemUser.find_by_username(username)
        begin
          if user.nil? or user.auth_mode.nil?
            Heyday::AuthManager.all.each do |mode|
              user_id = mode.new(username, password).authenticate
              return user_id unless user_id.nil?
            end
          else
            mode = Heyday::AuthManager.find(user.auth_mode.to_sym)
            mode.new(username, password).authenticate
          end
        rescue AuthModeNotFound, Exception => e
            flash[:auth_mode_exception] = e.message
            return nil
        end
      end

      def require_heyday_login
        login params[:username], params[:password]
      end

      module ClassMethods
      end
    end
  end
end
