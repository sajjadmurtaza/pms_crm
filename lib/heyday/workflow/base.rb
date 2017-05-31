module Heyday
  module Workflow
    class Base
      attr_accessor :name, :actor, :states, :initial_state, :transitions, :actions
      attr_accessor :source
      attr_accessor :current_state

      def initialize(file, source=nil)
        workflow = YAML.load_file('config/lead_workflow.yml').deep_symbolize_keys
        @name = workflow[:name]
        @actor = workflow[:actor]
        @states = workflow[:states]
        @initial_state = workflow[:initial_state]
        @transitions = workflow[:transitions]
        @actions = workflow[:actions]

        if source
          @source = source
          @current_state = source.new_record? ? @initial_state : source.send(source.class.state_column)
        end
      end

      def can_transit_to?(state)
        state = state.to_s
        check_valid_state!(state)

        @transitions.each do |transition_name, transition|
          return transition_name if (transition.first == current_state and transition.last == state) or (transition.first == state and transition.last == current_state)
        end
        false
      end

      def transit_to!(state)
        state = state.to_s
        check_valid_state!(state)
        transition = can_transit_to?(state)
        raise ArgumentError.new("Can't transit to the state '#{state}' from #{@current_state}") unless transition

        if @current_state == @transitions[transition].last
          @source.update_attribute @source.class.state_column, state
          @current_state =  @source.send(@source.class.state_column)
        else
          perform_actions fetch_actions(:before, transition)
          @source.update_attribute @source.class.state_column, state
          @current_state =  @source.send(@source.class.state_column)
          perform_actions fetch_actions(:after, transition)
        end
      end

      private
      def check_valid_state!(state)
        raise ArgumentError.new("The state '#{state}' is not valid. Available options are #{@states.to_sentence}") unless @states.include? state
      end

      def check_valid_transition!(state)
        raise ArgumentError.new("Can't transit to the state '#{state}' from #{@current_state}") unless can_transit_to?(state)
      end

      def fetch_actions(mode, transition)
        actions = []
        @actions.each do |action_name, action|
          actions << action_name if action[mode].include?(transition.to_s)
        end
        actions
      end

      def perform_actions(actions)
        actions.each do |action|
          perfom_action(action)
        end
      end

      def perform_action(action_name, options = {})
        action = @actions[action_name]
        params = action[:params]
        params.keys.each do |key|
          puts "proc{|object| #{params[key]} }"
          params[key] = eval("proc{|object| #{params[key]} }").call(@source)
          params[:action_name] = action_name
        end
        params = params.merge(options)
        action[:action_class].constantize.new(params).perform
      end
    end
  end
end