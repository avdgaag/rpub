module Rpub
  module Commands
    class Compile < Command
      def run
        Rpub::Compressor.open(book.filename) do |zip|
          Rpub::Epub.new(book, source.read(context.styles)).manifest_in(zip)
        end
      end
    end
  end
end
