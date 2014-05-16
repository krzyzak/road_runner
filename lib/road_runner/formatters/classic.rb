module RoadRunner
  module Formatters
    class Classic
      def success
        print "."
      end

      def fail
        print "F"
      end
    end
  end
end
