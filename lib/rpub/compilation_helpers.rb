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
                    File.expand_path('../../../support/layout.html', __FILE__)
                  end
    end

    def styles
      @styles ||= if File.exists?('styles.css')
                    'styles.css'
                  else
                    File.expand_path('../../../support/styles.css', __FILE__)
                  end
    end

    def config_file
      @config_file ||= 'config.yml'
    end
  end
end
