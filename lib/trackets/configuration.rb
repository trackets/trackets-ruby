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

    DEFAULT_API_URL = "https://trackets.com"

    attr_accessor :api_url, :api_key, :environment_name, :project_root, :framework, :whitelisted_env

    def initialize
      @api_url = DEFAULT_API_URL
      @whitelisted_env = DEFAULT_WHITELISTED_ENV_KEYS
    end

  end
end
