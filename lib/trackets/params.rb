module Trackets
  class Params

    attr_reader :rack_env

    def initialize(rack_env)
      @rack_env = rack_env
    end

    def rack_filter_keys
      @rack_filter_keys ||= Array(rack_env["action_dispatch.parameter_filter"])
    end

    def request
      @request ||= Rack::Request.new(rack_env)
    end

    def hash
      @hash ||= request.params
    end

    def blacklisted_keys
      @blacklisted_keys ||= (Trackets.configuration.blacklisted_params + rack_filter_keys).map(&:to_s)
    end

    def blacklisted?(key)
      blacklisted_keys.include?(key)
    end

    def filtered
      hash.inject({}) do |ret, (key, value)|
        ret[key] = if value.kind_of?(Hash)
          self.class.new(value).filtered
        else
          blacklisted?(key) ? "[FILTERED]" : value
        end

        ret
      end
    end

  end
end
