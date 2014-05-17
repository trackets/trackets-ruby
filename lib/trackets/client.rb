require "httparty"
require "trackets/backtrace"
require "trackets/params"

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

    def params
      @params ||= Params.new(env)
    end

    def whitelisted_env
      env.reject { |k,v| !Trackets.configuration.whitelisted_env.include?(k) }
    end

    def filtered_env
      whitelisted_env.inject({}) do |result, (key, val)|
        result[key] = filter_env_val(val) if key && val =~ /\S/
        result
      end
    end

    def filter_env_val(value)
      value.scan(/(?:^|&|\?)([^=?&]+)=([^&]+)/).each do |match|
        next unless params.blacklisted?(match[0])
        value.gsub!(/#{match[1]}/, '[FILTERED]')
      end

      value
    end

    def payload
      {
        language:         "ruby",
        message:          exception.message,
        class_name:       exception.class.to_s,
        stacktrace:       backtrace.parse.join("\n"),
        env:              filtered_env,
        environment_name: config.environment_name,
        project_root:     config.project_root,
        framework:        config.framework,
        params:           params.filtered
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
