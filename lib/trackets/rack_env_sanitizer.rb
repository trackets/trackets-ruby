module Trackets
  class RackEnvSanitizer

    attr_reader :rack_env

    def initialize(rack_env)
      @rack_env = rack_env
    end

    def filtered
      whitelisted_env.inject({}) do |result, (key, val)|
        result[key] = filter_val(val) if key && val =~ /\S/
        result
      end
    end

    private
    def whitelisted_env
      rack_env.reject { |k,v| !Trackets.configuration.whitelisted_env.include?(k) }
    end

    def filter_val(value)
      value.scan(/(?:^|&|\?)([^=?&]+)=([^&]+)/).each do |match|
        next unless Trackets.configuration.blacklisted_key?(match[0], rack_env)
        value.gsub!(/#{match[1]}/, '[FILTERED]')
      end

      value
    end

  end
end
