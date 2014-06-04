require 'term/ansicolor'

module RoadRunner
  module Formatters
    class Color
      include Term::ANSIColor

      def success
        print green(".")
      end

      def fail
        print red("F")
      end

      def skip
        print yellow("S")
      end

      def error
        print red("E")
      end
    end
  end
end
