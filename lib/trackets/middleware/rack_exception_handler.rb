module Trackets
  module Middleware
    class RackExceptionHandler

      def initialize(app)
        @app = app
      end

      def call(env)
        response = @app.call(env)
      rescue RuntimeError => exception
        Trackets.notify(exception, env)
        raise exception
      end

    end
  end
end
