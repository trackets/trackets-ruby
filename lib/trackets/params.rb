module Trackets
  class Params

    attr_reader :rack_env

    def initialize(rack_env)
      @rack_env = rack_env
    end

    def request
      @request ||= Rack::Request.new(rack_env)
    end

    def hash
      @hash ||= request.params
    end

    def filtered
      hash.inject({}) do |ret, (key, value)|
        ret[key] = if value.kind_of?(Hash)
          self.class.new(value).filtered
        else
          Trackets.configuration.blacklisted_key?(key, rack_env) ? "[FILTERED]" : value
        end

        ret
      end
    end

  end
end
