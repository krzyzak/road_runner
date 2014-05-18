module RoadRunner
  class Runner
    attr_reader :files, :monitor, :methods_filter, :random, :fail_fast

    def initialize(files, methods_filter: ".*", seed: rand(10_000), fail_fast:)
      @fail_fast = fail_fast
      @random = Random.new(seed.to_i)
      @files = files
      @methods_filter = methods_filter

      reporter.report_seed_value(random)
      require_files
    end

    def run!
      suites.each do |suite|
        run_suite!(suite)
      end
      reporter.report
    end

    private
    def require_files
      files.each do |file|
        require file
      end
    end

    def run_suite!(suite)
      monitor.suite(suite.name) do
        test_methods(suite).each do |test|
          reporter.increment_tests_count!
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
          return if fail_fast
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
      klass.public_methods(false).select{|m| m[0, 4] == "test" && matches_method_filter?(m) }.shuffle(random: random)
    end

    def matches_method_filter?(method_name)
      !!method_name.match(Regexp.new(methods_filter))
    end

    def suites
      @suites ||= begin
        suites = []
        ObjectSpace.each_object(class << MiniTest::Test; self; end) do |klass|
          suites << klass.new(klass) unless klass == self
        end
        suites.shuffle(random: random)
      end
    end
  end
end
