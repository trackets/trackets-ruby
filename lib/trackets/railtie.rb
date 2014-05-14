require "trackets/view_helpers"
require "trackets/middleware/rack_exception_handler"

module Trackets
  class Railtie < Rails::Railtie

    initializer "trackets.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    initializer "trackets.configure_rails_initialization" do |app|
      after = defined?(ActionDispatch::DebugExceptions) ? "ActionDispatch::DebugExceptions" : "ActionDispatch::ShowExceptions"

      app.config.middleware.insert_after after, "Trackets::Middleware::RackExceptionHandler"
    end

    config.after_initialize do
      Trackets.setup do |config|
        config.environment_name ||= ::Rails.env
        config.project_root     ||= ::Rails.root.to_s
        config.framework        = "Rails: #{::Rails::VERSION::STRING}"
      end
    end

  end
end
