module RoadRunner
  class Runner
    attr_reader :files

    def initialize(files)
      files.each do |file|
        require file
      end
    end

    def run!
      suites.each do |suite|
        test_methods(suite).each do |test|
          begin
            suite.public_send(test)
          rescue Minitest::Assertion => e
            reporter.fail(e)
            formatter.fail
          end
          formatter.success
        end
      end
      reporter.report
    end

    private
    def formatter
      @formatter ||= Formatters::Classic.new
    end

    def reporter
      @reporter ||= Reporters::Classic.new
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
