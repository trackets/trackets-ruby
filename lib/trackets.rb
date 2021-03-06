require "trackets/version"
require "trackets/railtie" if defined?(Rails)
require "trackets/middleware/rack_exception_handler"
require "trackets/configuration"
require "trackets/plugins/loader"
require "trackets/jobs/notice_job"

module Trackets
  class << self

    def setup
      yield(configuration)

      Plugins::Loader.new
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def notify(exception, env = nil, additional_info = nil)
      return unless Trackets.configuration.enabled?

      job = NoticeJob.new
      job = job.async if Trackets.configuration.async?

      job.perform(exception, env, additional_info)
    end

    class TracketsCustomException < StandardError; end

    def send_custom_exception(message = nil)
      begin
        raise TracketsCustomException, message
      rescue TracketsCustomException => e
        force { Trackets.notify(e) }
      end
    end

    def force(&block)
      original = configuration.force?
      configuration.force = true

      yield

      configuration.force = original
    end

  end
end
