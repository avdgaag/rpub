module RPub
  module Commands
    class Preview < Base
      include CompilationHelpers

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
          f.write Kramdown::Document.new(concatenation, KRAMDOWN_OPTIONS.merge(:template => layout)).to_html
        end
      end

    private

      def parser
        OptionParser.new do |opts|
          opts.banner = <<-EOS
Usage: rpub preview [options]

Generate a single-page HTML file for easy previewing of your content with the
layout and styles used when generating .epub files. By default, the output
file will be named "preview.html".

Options:
EOS
          opts.separator ''
          opts.on '-l', '--layout FILENAME', 'Specify an explicit layout file to use' do |filename|
            @layout = filename
          end

          opts.on '-o', '--output FILENAME', 'Specify an explicit output file' do |filename|
            @filename = filename
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
