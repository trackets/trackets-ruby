module Trackets
  class Configuration

    DEFAULT_WHITELISTED_ENV_KEYS = [
      "REQUEST_METHOD",
      "PATH_INFO",
      "QUERY_STRING",
      "SCRIPT_NAME",
      "REMOTE_ADDR",
      "SERVER_ADDR",
      "SERVER_NAME",
      "SERVER_PORT",
      "HTTP_HOST",
      "HTTP_CONNECTION",
      "CONTENT_LENGTH",
      "HTTP_ACCEPT",
      "HTTP_ORIGIN",
      "HTTP_USER_AGENT",
      "CONTENT_TYPE",
      "HTTP_REFERER",
      "HTTP_ACCEPT_ENCODING",
      "HTTP_ACCEPT_LANGUAGE",
      "REMOTE_PORT",
      "ORIGINAL_FULLPATH"
    ].freeze
    DEFAULT_BLACKLISTED_PARAMS = ["password", "password_confirmation", "card_number", "cvv"].freeze
    DEFAULT_API_URL = "https://trackets.com"
    DEFAULT_LOAD_PLUGINS = [:sidekiq]
    DEFAULT_ENABLED_ENV = [:production]

    attr_accessor :api_url, :api_key, :environment_name, :project_root, :framework, :whitelisted_env, :blacklisted_params, :async,
      :load_plugins, :enabled_env, :force
    alias_method :async?, :async
    alias_method :force?, :force

    def initialize
      @api_url = DEFAULT_API_URL
      @whitelisted_env = DEFAULT_WHITELISTED_ENV_KEYS
      @blacklisted_params = DEFAULT_BLACKLISTED_PARAMS
      @async = false
      @load_plugins = DEFAULT_LOAD_PLUGINS
      @enabled_env = DEFAULT_ENABLED_ENV
      @force = false
    end

    def rack_filter_keys(rack_env = nil)
      @rack_filter_keys ||= rack_env ? Array(rack_env["action_dispatch.parameter_filter"]) : []
    end

    def blacklisted_keys(rack_env = nil)
      @blacklisted_keys ||= (blacklisted_params + rack_filter_keys).map(&:to_s)
    end

    def blacklisted_key?(key, rack_env = nil)
      blacklisted_keys.include?(key)
    end

    def enabled?
      enabled_env.include?(environment_name.to_sym) || force?
    end

  end
end
