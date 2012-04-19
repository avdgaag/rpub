module Rpub
  module Commands
    class Help < Base
      identifier 'help'

      def invoke
        if options.empty?
          Main.new.invoke
        else
          Base.matching(options.shift).new.help
        end
      end

    private

      def parser
        OptionParser.new do |opts|
          opts.banner = <<-EOS
Usage: rpub help subcommand

Describe the usage and options for rpub subcommands.

Options:
EOS
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
