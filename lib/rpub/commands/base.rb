module RPub
  module Commands
    class Base
      extend SubclassTracker

      attr_reader :options

      def initialize(options = [], stdout = $stdout)
        @options, @stdout = options, stdout
      end

      def invoke
        parser.parse!(options)
      end

      def help
        puts parser
      end

    protected

      def parser
        OptionParser.new
      end

    private

      def puts(*args)
        @stdout.puts(*args)
      end
    end
  end
end
