module Heyday
  module Workflow
    module DataEntity
      extend ActiveSupport::Concern

      included do
        cattr_accessor :workflow_class, :state_column
        before_create :set_initial_state
      end

      module ClassMethods
        def workflow(options)
          self.workflow_class = options[:workflow_class] || "#{self.class.to_s}Flow".constantize
          self.state_column = options[:state_column] || 'state'
        end
      end

      def workflow
        @workflow ||= self.class.workflow_class.to_s.constantize.new(self)
      end

      private
      def set_initial_state
        self.send "#{self.class.state_column}=", workflow.initial_state if (self.send self.class.state_column).nil?
      end
    end
  end
end
