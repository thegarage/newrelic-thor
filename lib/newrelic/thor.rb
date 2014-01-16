require "thor"
require 'new_relic/agent/method_tracer'
require "newrelic/thor/version"

module NewRelic
  module Thor
    class << self
      def started?
        !!@started
      end
      def start
        return if started?
        ::NewRelic::Agent.manual_start(:dispatcher => :thor)
        @started = true
      end
      def disabled?
        !!::NewRelic::Control.instance['disable_thor']
      end
    end

    module Instrumentation
      BLACKLISTED_COMMAND_NAMES = %w{ help }

      def self.included(base)
        base.class_eval do
          include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

          no_commands do
            alias_method :invoke_command_original, :invoke_command
            def invoke_command(*args)
              command = args.first
              return unless perform_trace_for_command?(command)
              ::NewRelic::Thor.start
              trace_options = {
                :class_name => self.class.name,
                :name => command.name,
                :category => "OtherTransaction/Thor"
              }
              perform_action_with_newrelic_trace(trace_options) do
                invoke_command_original(*args)
              end
            end
          end

          private

          def perform_trace_for_command?(command)
            !BLACKLISTED_COMMAND_NAMES.include?(command.name)
          end
        end
      end
    end
  end
end

DependencyDetection.defer do
  @name = :thor

  depends_on do
    defined?(::Thor) && !::NewRelic::Thor.disabled?
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing Thor instrumentation'
  end

  executes do
    ::Thor.send(:include, ::NewRelic::Thor::Instrumentation)
  end
end
