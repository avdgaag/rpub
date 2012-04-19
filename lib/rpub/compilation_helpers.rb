module Rpub
  module CompilationHelpers
    def create_book
      book = Book.new(layout, config)
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
                    Rpub.support_file('layout.html')
                  end
    end

    def styles
      @styles ||= if File.exists?('styles.css')
                    'styles.css'
                  else
                    Rpub.support_file('styles.css')
                  end
    end

    def config
      @config_file ||= begin
        raise NoConfiguration unless File.exist?('config.yml')
        YAML.load_file('config.yml')
      end
    end
  end
end
