module RoadRunner
  class Runner
    attr_reader :files, :monitor

    def initialize(files)
      files.each do |file|
        require file
      end
    end

    def run!
      suites.each do |suite|
        run_suite!(suite)
      end
      reporter.report
    end

    private
    def run_suite!(suite)
      monitor.suite(suite.name) do
        test_methods(suite).each do |test|
          run_test!(suite, test)
        end
      end
    end

    def run_test!(suite, test)
      monitor.test(test) do
        begin
          suite.public_send(test)
        rescue Minitest::Assertion => e
          reporter.fail(e)
          formatter.fail
        end
        formatter.success
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

    def test_methods(klass)
      klass.public_methods(false).select{|m| m[0, 4] == "test" }
    end

    def suites
      @suites ||= begin
        suites = []
        ObjectSpace.each_object(class << MiniTest::Test; self; end) do |klass|
          suites.unshift klass.new(klass) unless klass == self
        end
        suites
      end
    end
  end
end
