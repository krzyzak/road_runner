require "mixlib/cli"

module RoadRunner
  class CLI
    include Mixlib::CLI

    def run
      path = parse_options

      Runner.new(path).run!
    end
  end
end
