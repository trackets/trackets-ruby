# Middleware for Rack applications
#
# Example of a basic Rack app
#
#   require 'rack'
#   require 'trackets'
#
#   Trackets.setup do |config|
#     config.private_api_key = "insert-valid-api-key"
#   end
#
#   app = Rack::Builder.app do
#     run lambda { |env| raise "Testing Error" }
#   end
#
#   use Trackets::Middleware::RackExceptionHandler
#   run app

module Trackets
  module Middleware
    class RackExceptionHandler

      def initialize(app)
        @app = app
      end

      def call(env)
        response = @app.call(env)
      rescue Exception => exception
        Trackets.notify(exception, env)
        raise
      end

    end
  end
end
