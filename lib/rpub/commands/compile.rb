module RPub
  module Commands
    class Compile < Base
      identifier 'compile'

      def invoke
        super

        book = Book.new(layout, YAML.load_file(config_file))
        markdown_files.each(&book.method(:<<))

        Compressor.open(book.filename) do |zip|
          Epub.new(book, layout).manifest_in(zip)
        end
      end

      module Helpers
        def markdown_files
          @markdown_files ||= Dir['*.md'].sort.map(&File.method(:read))
        end

        def layout
          @layout ||= if File.exist?('layout.html')
            'layout.html'
          else
            File.expand_path('../../../../support/layout.html', __FILE__)
          end
        end
      end
      include Helpers

    private

      def parser
        OptionParser.new do |opts|
          opts.on '-l', '--layout FILENAME', 'Specify an explicit layout file to use' do |filename|
            @layout = filename
          end

          opts.on '-c', '--config FILENAME', 'Specify an explicit configuration file to use' do |filename|
            @config_file = filename
          end
        end
      end

      def config_file
        @config_file ||= 'config.yml'
      end
    end
  end
end
