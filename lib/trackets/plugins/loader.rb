module Trackets
  module Plugins
    class Loader

      def initialize
        Trackets.configuration.load_plugins.each do |plugin_name|
          require "trackets/plugins/#{plugin_name}"

          class_name = plugin_name.to_s.split('_').map{|e| e.capitalize}.join
          Trackets::Plugins.const_get(class_name).new
        end
      end

    end
  end
end
