module Rpub
  module Commands
    class Generate < Base
      identifier 'generate'

      def initialize(*args)
        super
        @all = true
      end

      def invoke
        super

        if (@styles.nil? && @all) || (!@styles.nil? && @styles)
          write_file Rpub.support_file('styles.css')
        end

        if (@layout.nil? && @all) || (!@layout.nil? && @layout)
          write_file Rpub.support_file('layout.html')
        end

        if (@config.nil? && @all) || (!@config.nil? && @config)
          write_file Rpub.support_file('config.yml')
        end
      end

    private

      def write_file(file)
        output_file = File.basename(file)
        if File.exist?(output_file)
          warn "Not overriding #{output_file}"
          return
        end
        File.open(output_file, 'w') do |f|
          f.write File.read(file)
        end
      end

      def parser
        OptionParser.new do |opts|
          opts.banner = <<-EOS
Usage: rpub generate [-slach]

Generate one or more standard files to get started with a new project.  By
default an entire skeleton project is generated, but by passing the -s, -l, -c
options you can generate just a single file.

Options:
EOS
          opts.separator ' '

          opts.on '-s', '--[no-]styles', 'Generate default stylesheet' do |v|
            @all = false if v
            @styles = v
          end

          opts.on '-l', '--[no-]layout', 'Generate default HTML layout' do |v|
            @all = false if v
            @layout = v
          end

          opts.on '-c', '--[no-]config', 'Generate default configuration' do |v|
            @all = false if v
            @config = v
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
