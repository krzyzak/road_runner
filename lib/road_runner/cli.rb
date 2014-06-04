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

    option :color,
      long: "--color",
      default: false,
      boolean: true

    def run
      path = parse_options.empty? ? Dir["test/**/*_test.rb"] : parse_options
      $:.unshift File.expand_path("test", Dir.pwd)

      Runner.new(path, config).run!
    end
  end
end
