module RoadRunner
  class FileRunner
    attr_reader :random, :monitor, :formatter, :reporter, :methods_filter, :fail_fast
    attr_accessor :test_case

    def initialize(random:, test_case: nil, monitor:, formatter:, reporter:, methods_filter:, fail_fast:)
      @fail_fast = fail_fast
      @random = random
      @test_case = test_case
      @monitor = monitor
      @formatter = formatter
      @reporter = reporter
      @methods_filter = methods_filter
    end

    def run!
      monitor.test_case(test_case.name) do
        test_methods(test_case).each do |test|
          reporter.increment_tests_count!
          test_case.run_callbacks(:setup) if active_support_test?
          run_test!(test_case, test)
          test_case.run_callbacks(:teardown) if active_support_test?
        end
      end
    end

    def test_methods(klass)
      klass.public_methods(false).select{|m| m[0, 4] == "test" && matches_method_filter?(m) }.shuffle(random: random)
    end

    private
    def run_test!(test_case, test)
      monitor.test(test) do
        begin
          test_case.public_send(test)
        rescue Minitest::Skip => e
          formatter.skip
        rescue Minitest::Assertion => e
          reporter.fail(e)
          formatter.fail
          test_case.run_callbacks(:teardown) if active_support_test?
          return if fail_fast
        rescue Exception => e
          reporter.error(e)
          formatter.error
          return if fail_fast
        end
        formatter.success
      end
    end

    def matches_method_filter?(method_name)
      !!method_name.match(Regexp.new(methods_filter))
    end

    def active_support_test?
      defined?(ActiveSupport::TestCase) && test_case.is_a?(ActiveSupport::TestCase)
    end
  end
end
