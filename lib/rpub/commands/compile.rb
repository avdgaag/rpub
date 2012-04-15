module RPub
  module Commands
    class Compile < Base
      include CompilationHelpers

      identifier 'compile'

      def invoke
        super
        book = create_book
        Compressor.open(book.filename) do |zip|
          Epub.new(book, File.read(styles)).manifest_in(zip)
        end
      end

    private

      def parser
        OptionParser.new do |opts|
          opts.banner = <<-EOS
Usage: rpub compile [options]

Compile your Markdown-formatted input files to a valid .epub output
file using the options described in config.yml. This will use the
layout.html and styles.css files in your project directory if
present.

Options:
EOS
          opts.separator ''

          opts.on '-l', '--layout FILENAME', 'Specify an explicit layout file to use' do |filename|
            @layout = filename
          end

          opts.on '-s', '--styles FILENAME', 'Specify an explicit stylesheet file to use' do |filename|
            @styles = filename
          end

          opts.on '-c', '--config FILENAME', 'Specify an explicit configuration file to use' do |filename|
            @config_file = filename
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
    end
  end
end
