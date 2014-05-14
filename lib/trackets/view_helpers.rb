module Trackets
  module ViewHelpers
    def trackets_include_tag
      javascript_include_tag "//trackets.s3.amazonaws.com/client.js"
    end
  end
end
