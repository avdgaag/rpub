module Rpub
  module Commands
    class Clean < Command
      def run
        source.remove book.filename, options.dryrun
        source.remove 'preview.html', options.dryrun
      end
    end
  end
end
