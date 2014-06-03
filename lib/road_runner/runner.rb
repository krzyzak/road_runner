require "road_runner/minitest_patch"

module RoadRunner
  class Runner
    attr_reader :files, :random, :file_runner

    def initialize(files, methods_filter: ".*", seed: rand(10_000), fail_fast:)
      Rails.env = "test" if defined?(Rails)

      @random = Random.new(seed.to_i)
      @files = files
      @file_runner = FileRunner.new(random: random, monitor: monitor, formatter: formatter, reporter: reporter, methods_filter: methods_filter, fail_fast: fail_fast)

      reporter.report_seed_value(random)
      require_files
    end

    def run!
      test_cases.each do |test_case|
        with_active_record_transaction do
          file_runner.test_case = test_case
          file_runner.run!
        end
      end

      reporter.report
    end

    private
    def with_active_record_transaction(&block)
      return yield unless defined?(ActiveRecord)

      ActiveRecord::Base.connection.begin_transaction(joinable: false)
      yield
      ActiveRecord::Base.connection.rollback_transaction
    end

    def require_files
      files.each do |file|
        require file
      end
    end

    def monitor
      @monitor ||= Monitor.new
    end

    def formatter
      @formatter ||= Formatters::Classic.new
    end

    def reporter
      @reporter ||= Reporters::Classic.new(monitor: monitor)
    end

    def test_cases
      @test_cases ||= begin
        test_cases = []
        ObjectSpace.each_object(class << MiniTest::Test; self; end) do |klass|
          object = klass.new(klass)
          test_cases << object if klass != self && !file_runner.test_methods(object).empty?
        end
        test_cases.shuffle(random: random)
      end
    end
  end
end
