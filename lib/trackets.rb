require "trackets/version"
require "trackets/railtie" if defined?(Rails)
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

    def notify(exception, env)
      Client.notify(exception, env)
    end

  end
end
