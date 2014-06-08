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
