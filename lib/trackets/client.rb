require "httparty"
require "trackets/backtrace"

module Trackets
  class Client

    include HTTParty

    class << self

      def notify(exception, env)
        new(exception, env).send
      end

    end

    attr_reader :exception, :env

    def initialize(exception, env)
      @exception = exception
      @env = env
    end

    def backtrace
      @backtrace ||= Backtrace.new(exception.backtrace)
    end

    def whitelisted_env
      env.reject { |k,v| !Trackets.configuration.whitelisted_env.include?(k) }
    end

    def payload
      {
        language:         "ruby",
        message:          exception.message,
        class_name:       exception.class.to_s,
        stacktrace:       backtrace.parse.join("\n"),
        env:              whitelisted_env,
        environment_name: config.environment_name,
        project_root:     config.project_root,
        framework:        config.framework
      }
    end

    def config
      Trackets.configuration
    end

    def send
      self.class.post "#{config.api_url}/reports/#{config.api_key}", body: { error: payload }
    end
  end
end
