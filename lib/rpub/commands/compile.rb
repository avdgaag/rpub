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
          opts.on '-l', '--layout FILENAME', 'Specify an explicit layout file to use' do |filename|
            @layout = filename
          end

          opts.on '-s', '--styles FILENAME', 'Specify an explicit stylesheet file to use' do |filename|
            @styles = filename
          end

          opts.on '-c', '--config FILENAME', 'Specify an explicit configuration file to use' do |filename|
            @config_file = filename
          end
        end
      end
    end
  end
end
