module RoadRunner
  class Monitor
    attr_reader :test_cases, :tests

    def initialize
      @start = Time.now
      @test_cases = {}
      @tests = {}
    end

    def test_case(name, &block)
      time = calculate_time(&block)
      @test_cases[name] = time
    end

    def test(name, &block)
      time = calculate_time(&block)
      @tests[name] = time
    end

    def total_execution_time
      Time.now - @start
    end

    private
    def calculate_time(&block)
      start_time = Time.now
      yield
      Time.now - start_time
    end
  end
end
