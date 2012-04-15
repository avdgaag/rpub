module RPub
  module CompilationHelpers
    def create_book
      book = Book.new(layout, YAML.load_file(config_file))
      markdown_files.each(&book.method(:<<))
      book
    end

    def markdown_files
      @markdown_files ||= Dir['*.md'].sort.map(&File.method(:read))
    end

    def layout
      @layout ||= if File.exist?('layout.html')
                    'layout.html'
                  else
                    RPub.support_file('layout.html')
                  end
    end

    def styles
      @styles ||= if File.exists?('styles.css')
                    'styles.css'
                  else
                    RPub.support_file('styles.css')
                  end
    end

    def config_file
      @config_file ||= 'config.yml'
    end
  end
end
