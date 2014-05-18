require "mixlib/cli"

module RoadRunner
  class CLI
    include Mixlib::CLI

    option :methods_filter,
      short: "-m method_name",
      long: "--method method_name"

    option :seed,
      short: "-s SEED",
      long: "--seed SEED"

    option :fail_fast,
      long: "--fail-fast",
      default: false,
      boolean: true

    def run
      path = parse_options

      Runner.new(path, config).run!
    end
  end
end
