module RPub
  module Commands
    class Main < Base

      def invoke
        options << '-h' if options.empty?
        super
        raise InvalidSubcommand, options[0] unless options.empty?
      end

    protected

      def parser
        OptionParser.new do |opts|
          opts.banner = <<-EOS
Usage: rpub [subcommand] [options]

Compile multiple Markdown-formatted input files into a machine-readable epub
file for distribution as an ebook.

Available subcommands:

  compile
  preview
  clean
  package
  help
EOS

          opts.separator ''
          opts.separator 'Generic options:'
          opts.separator ''

          opts.on_tail '-v', '--version', 'Display version information' do
            puts "rpub #{RPub::VERSION}"
          end

          opts.on_tail '-h', '--help', 'Display command reference' do
            puts opts
          end
        end
      end
    end
  end
end
