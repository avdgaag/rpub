module Rpub
  # Provide a set of helper methods that are used across various commands to
  # simplify the compilation process. These methods mostly deal with loading files
  # from the current project directory.
  module CompilationHelpers

    # Factory method for {Rpub::Book} objects, loading every markdown file as a
    # chapter.
    #
    # @see #markdown_files
    # @return [Rpub::Book]
    def create_book
      book = Book.new(layout, config)
      markdown_files.each(&book.method(:<<))
      book
    end

    # All chapter input files loaded into strings. This does not include any of
    # the files listed in the +ignore+ configuration key.
    #
    # @return [Array<String>]
    def markdown_files
      @markdown_files ||= filter_exceptions(Dir['*.md']).sort.map(&File.method(:read))
    end

    # @return [String] path to the current layout file (defaulting to built-in)
    def layout
      @layout ||= own_or_support_file('layout.html')
    end

    # @return [String] path to the current stylesheet file (defaulting to built-in)
    def styles
      @styles ||= own_or_support_file('styles.css')
    end

    # Load the contents of +config.yml+ into a +Hash+ object.
    #
    # @raise [NoConfiguration] when the config file cannot be found.
    # @return [Hash] parsed configuration
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
