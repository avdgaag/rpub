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
    end
  end
end
