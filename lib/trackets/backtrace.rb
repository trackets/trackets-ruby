module Trackets
  class Backtrace

    attr_reader :backtrace

    def initialize(backtrace)
      @backtrace = backtrace
    end

    def parse
      backtrace.map do |line|
        next if line =~ %r{lib/trackets}

        line.sub!(Trackets.configuration.project_root, "[PROJECT_ROOT]") if Trackets.configuration.project_root

        if defined?(Gem)
          Gem.path.inject(line) { |current, path| current.sub(path, "[GEM_ROOT]") }
        end
      end.compact
    end

  end
end
