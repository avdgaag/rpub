module Rpub
  module CompilationHelpers
    def create_book
      book = Book.new(layout, config)
      markdown_files.each(&book.method(:<<))
      book
    end

    def markdown_files
      @markdown_files ||= filter_exceptions(Dir['*.md']).sort.map(&File.method(:read))
    end

    def layout
      @layout ||= own_or_support_file('layout.html')
    end

    def styles
      @styles ||= own_or_support_file('styles.css')
    end

    def config
      @config_file ||= begin
        raise NoConfiguration unless File.exist?('config.yml')
        YAML.load_file('config.yml') || {}
      end
    end

  private

    def filter_exceptions(filenames)
      return filenames unless config.has_key?('ignore')
      filenames.reject(&config['ignore'].method(:include?))
    end

    def own_or_support_file(filename)
      if File.exists?(filename)
        filename
      else
        Rpub.support_file(filename)
      end
    end
  end
end
