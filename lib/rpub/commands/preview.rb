module Rpub
  module Commands
    class Preview < Command
      def run
        options.default :output => 'preview.html'
        source.force_write options.output, Rpub::Preview.new(context, source).formatted
      end
    end
  end
end
