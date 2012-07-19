module Rpub
  module Commands
    class Package < Command
      def run
        Compile.new(args, options)
        if context.config['package_file']
          Rpub::Compressor.open(context.config['package_file']) do |zip|
            zip.store_file book.filename, source.read(book.filename)
            Array(context.config['package']).each do |file|
              zip.compress_file file, source.read(file)
            end
          end
        end
      end
    end
  end
end
