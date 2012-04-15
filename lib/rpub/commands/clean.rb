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
          opts.banner = <<-EOS
Usage: rpub clean [-d]'

Clean up all generated files, such as the standard generated .epub
file, package files and preview files.

Options:
EOS

          opts.separator ''

          opts.on '-d', '--dry-run', 'Dry-run: only list files to be removed' do
            @dry_run = true
          end

          opts.separator ''
          opts.separator 'Generic options:'
          opts.separator ''

          opts.on_tail '-h', '--help', 'Display this message' do
            puts opts
            exit
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
