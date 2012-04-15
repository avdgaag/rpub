module RPub
  module Commands
    class Package < Base
      include CompilationHelpers

      identifier 'package'

      def invoke
        super
        Compile.new(options).invoke
        config = YAML.load_file(config_file)
        return unless config.has_key?('package_file')
        Compressor.open(config.fetch('package_file')) do |zip|
          zip.store_file create_book.filename, File.read(create_book.filename)
          config.fetch('package') { [] }.each do |file|
            zip.compress_file file, File.read(file)
          end
        end
      end

    private

      def parser
        OptionParser.new do |opts|
          opts.banner = <<-EOS
Usage: rpub package

Compile your ebook to an ePub file and package it into an archive together with
optional other files for easy distibution. You might want to include a README
file, a license or other promotion material.

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
