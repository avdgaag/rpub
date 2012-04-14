module RPub
  module Commands
    class Preview < Base
      include Compile::Helpers

      identifier 'preview'

      def initialize(*args)
        super
        @filename = 'preview.html'
      end

      def invoke
        super
        return unless markdown_files.any?
        concatenation = markdown_files.join("\n")
        File.open(@filename, 'w') do |f|
          f.write Kramdown::Document.new(concatenation, :template => layout).to_html
        end
      end

    private

      def parser
        OptionParser.new do |opts|
          opts.on '-l', '--layout FILENAME', 'Specify an explicit layout file to use' do |filename|
            @layout = filename
          end

          opts.on '-o', '--output FILENAME', 'Specify an explicit output file' do |filename|
            @filename = filename
          end
        end
      end
    end
  end
end
