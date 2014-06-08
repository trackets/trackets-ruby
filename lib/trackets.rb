require "trackets/version"
require "trackets/railtie" if defined?(Rails)
require "trackets/middleware/rack_exception_handler"
require "trackets/configuration"
require "trackets/client"

module Trackets
  class << self

    def setup
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def notify(exception, env = nil)
      Client.notify(exception, env)
    end

    class TracketsCustomException < StandardError; end

    def send_custom_exception(message = nil)
      begin
        raise TracketsCustomException, message
      rescue TracketsCustomException => e
        Trackets.notify(e)
      end
    end

  end
end
