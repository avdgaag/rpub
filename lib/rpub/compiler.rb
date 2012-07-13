module Rpub
  # Provide a set of helper methods that are used across various commands to
  # simplify the compilation process. These methods mostly deal with loading files
  # from the current project directory.
  class Compiler
    def initialize(options = {})
      @config_file = options[:config]
      @layout      = options[:layout]
      @styles      = options[:styles]
    end

    # Factory method for {Rpub::Book} objects, loading every markdown file as a
    # chapter.
    #
    # @return [Rpub::Book]
    def book
      @book ||= begin
        book = Book.new(layout, config, fonts)
        chapter_files.each(&book.method(:<<))
        book
      end
    end

    def preview
      return unless chapter_files.any?
      move_styles_inline(
        Typogruby.improve(
          preview_content
        )
      )
    end

    def preview_content
      Kramdown::Document.new(
        chapter_files.join("\n"),
        KRAMDOWN_OPTIONS.merge(:template => layout)
      ).to_html
    end

    def config
      @config ||= YAML.load_file(config_file) || {}
    end

    # @return [String] path to the current layout file (defaulting to built-in)
    def layout
      @layout ||= own_or_support_file('layout.html')
    end

    # @return [String] path to the current stylesheet file (defaulting to built-in)
    def styles
      @styles ||= own_or_support_file('styles.css')
    end

    private

    # All chapter input files loaded into strings. This does not include any of
    # the files listed in the +ignore+ configuration key.
    #
    # @return [Array<String>]
    def chapter_files
      @chapter_files ||= filter_exceptions(Dir['*.md']).sort.map(&File.method(:read))
    end

    def filter_exceptions(filenames)
      return filenames unless config[:ignore]
      filenames.reject(&config[:ignore].method(:include?))
    end

    def config_file
      @config_file ||= own_or_support_file('config.yml')
    end

    def own_or_support_file(filename)
      return filename if File.exists?(filename)
      Rpub.support_file(filename)
    end

    def fonts
      @fonts ||= File.read(styles).scan(/url\((?:'|")?([^'")]+\.otf)(?:'|")?\)/i).flatten
    end

    def move_styles_inline(html)
      style_block = %Q{<style>\n#{File.read(styles)}\n</style>}
      html.gsub %r{</head>}, style_block + "\n</head>"
    end
  end
end
