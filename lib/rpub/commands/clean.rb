module RPub
  module Commands
    class Clean < Base
      include CompilationHelpers

      identifier 'clean'

      def invoke
        super
        remove create_book.filename
        remove 'preview.html'
      end

    private

      def parser
        OptionParser.new do |opts|
          opts.on '-d', '--dry-run', 'Dry-run: only list files to be removed' do
            @dry_run = true
          end
        end
      end

      def remove(filename)
        if File.exist?(filename)
          unless @dry_run
            File.unlink(filename)
          else
            puts filename
          end
        end
      end
    end
  end
end
