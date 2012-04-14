module RPub
  module Commands
    class Preview < Base
      identifier 'preview'

      def initialize(*args)
        super
        @filename = 'preview.html'
      end

      def invoke
        super
        return unless markdown_files.any?
        concatenation = markdown_files.map(&File.method(:read)).join("\n")
        File.open(@filename, 'w') do |f|
          f.write Kramdown::Document.new(concatenation, template: 'document').to_html
        end
      end

    private

      def parser
        OptionParser.new do |opts|
          opts.on '-o', '--output FILENAME', 'Specify an explicit output file' do |filename|
            @filename = filename
          end
        end
      end

      def markdown_files
        @markdown_files ||= Dir['*.md'].sort
      end
    end
  end
end
