module RPub
  module Commands
    class Compile < Base
      identifier 'compile'

      def invoke
        layout   = File.exist?('layout.html.erb') ? 'layout.html.erb' : nil

        book = Book.new YAML.load_file('config.yml')
        Dir['*.md'].each do |file|
          book << File.read(file)
        end

        Compressor.open(book.filename) do |zip|
          Epub.new(book, layout).manifest_in(zip)
        end
      end
    end
  end
end
