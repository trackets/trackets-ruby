module Trackets
  module ViewHelpers

    def trackets_include_tag
      if Trackets.configuration.enabled?
        javascript_include_tag "//trackets.s3.amazonaws.com/client.js", data: { "trackets-key" => Trackets.configuration.public_api_key }
      end
    end

  end
end
